using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;
using System.Globalization;

namespace Sagrisa.API.Controllers;

[Authorize]
public sealed class CobrosController(
    ICobroRepository cobroRepository,
    IFacturaRepository facturaRepository,
    IClienteRepository clienteRepository,
    IUsuarioRepository usuarioRepository) : SagrisaBaseController
{
    [HttpGet]
    public async Task<IActionResult> Obtener([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 50, [FromQuery] string? codCliente = null, [FromQuery] string? codVendedor = null, CancellationToken cancellationToken = default)
    {
        var allowed = await GetAllowedCustomerCodes(cancellationToken);
        var items = (await cobroRepository.ObtenerTodosAsync(cancellationToken)).Where(x => allowed is null || allowed.Contains(x.CodCliente));
        if (!string.IsNullOrWhiteSpace(codCliente)) items = items.Where(x => x.CodCliente.Equals(codCliente.Trim(), StringComparison.OrdinalIgnoreCase));
        if (!string.IsNullOrWhiteSpace(codVendedor)) items = items.Where(x => x.CodVendedor != null && x.CodVendedor.Equals(codVendedor.Trim(), StringComparison.OrdinalIgnoreCase));
        else if (IsSellerScope()) items = items.Where(x => x.CodVendedor != null && x.CodVendedor.Equals(CurrentUserCodVendedor, StringComparison.OrdinalIgnoreCase));
        var size = Math.Clamp(pageSize, 1, 200);
        var data = items.OrderByDescending(x => x.CreatedAt).Skip((Math.Max(1, pageNumber) - 1) * size).Take(size).Select(MapCobro).ToList();
        return Ok(new { success = true, message = "Cobros obtenidos.", data });
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> ObtenerPorId(Guid id, CancellationToken cancellationToken)
    {
        var cobro = await cobroRepository.ObtenerPorIdAsync(id, cancellationToken);
        if (cobro is null || !await CanAccessCustomer(cobro.CodCliente, cancellationToken)) return NotFound(new { success = false, message = "Cobro no encontrado." });
        return Ok(new { success = true, message = "Cobro obtenido.", data = MapCobro(cobro) });
    }

    [HttpGet("pending-invoices")]
    public async Task<IActionResult> ObtenerFacturasPendientes([FromQuery] string customerId, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(customerId) || !await CanAccessCustomer(customerId, cancellationToken)) return Forbid();
        var result = await facturaRepository.ObtenerPaginadoAsync(1, 200, customerId.Trim(), cancellationToken);
        var data = result.Items.Where(x => x.Saldo > 0 && x.Status is not InvoiceStatus.Paid and not InvoiceStatus.Cancelled).Select(x => new { id = x.Id, number = x.NumFactura, total = x.TotalFactura, balance = x.Saldo, date = x.FechaEmision.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) }).ToList();
        return Ok(new { success = true, message = "Facturas pendientes obtenidas.", data });
    }

    [Authorize(Roles = "Vendedor,Gerente,Admin")]
    [HttpPost]
    public async Task<IActionResult> Registrar([FromBody] RegistrarCobroRequest request, CancellationToken cancellationToken = default)
    {
        var factura = await ResolveFactura(request, cancellationToken);
        if (factura is null) return BadRequest(new { success = false, message = "La factura indicada no existe." });
        if (!await CanAccessCustomer(factura.CodCliente, cancellationToken)) return Forbid();
        var requestedCustomer = FirstNonEmpty(request.CodCliente, request.CustomerId);
        if (requestedCustomer is not null && !factura.CodCliente.Equals(requestedCustomer, StringComparison.OrdinalIgnoreCase)) return BadRequest(new { success = false, message = "La factura no pertenece al cliente indicado." });

        var reference = FirstNonEmpty(request.Referencia, request.Reference);
        var existing = (await cobroRepository.ObtenerTodosAsync(cancellationToken)).FirstOrDefault(x =>
            (request.Id.HasValue && x.Id == request.Id.Value) ||
            (reference is not null && x.FacturaId == factura.Id && string.Equals(x.Referencia, reference, StringComparison.OrdinalIgnoreCase)));
        if (existing is not null)
            return Ok(new { success = true, message = "Cobro ya registrado.", data = MapCobro(existing) });
        var amount = request.Monto ?? request.Amount ?? 0m;
        if (amount <= 0 || amount > factura.Saldo) return BadRequest(new { success = false, message = "El monto debe ser mayor que cero y no superar el saldo de la factura." });
        var paymentMethod = ParsePaymentMethod(request.MetodoPago ?? request.PaymentMethod);
        if (paymentMethod is null) return BadRequest(new { success = false, message = "Método de pago inválido." });
        var cobro = new Cobro { Id = request.Id.GetValueOrDefault(Guid.NewGuid()), FacturaId = factura.Id, NumFactura = factura.NumFactura, CodCliente = factura.CodCliente, CodVendedor = FirstNonEmpty(request.CodVendedor, CurrentUserCodVendedor), Monto = amount, MetodoPago = paymentMethod.Value, Referencia = reference, ComprobanteUrl = FirstNonEmpty(request.ComprobanteUrl, request.ReceiptFileName), FirmaUrl = FirstNonEmpty(request.FirmaUrl, request.SignatureDataUrl), Status = PaymentStatus.Pending, Notas = request.Notas, CreatedAt = DateTime.UtcNow };
        var created = await cobroRepository.CrearAsync(cobro, cancellationToken);
        return Ok(new { success = true, message = "Cobro registrado y pendiente de aprobación.", data = MapCobro(created) });
    }

    [Authorize(Roles = "Admin,Gerente")]
    [HttpPatch("{id:guid}/status")]
    public async Task<IActionResult> ActualizarEstado(Guid id, [FromBody] ActualizarCobroEstadoRequest request, CancellationToken cancellationToken = default)
    {
        var cobro = await cobroRepository.ObtenerPorIdAsync(id, cancellationToken);
        if (cobro is null) return NotFound(new { success = false, message = "Cobro no encontrado." });
        if (!Enum.TryParse<PaymentStatus>(request.Status, true, out var status)) return BadRequest(new { success = false, message = "Estado de cobro inválido." });
        if (status == PaymentStatus.Applied && cobro.Status != PaymentStatus.Applied)
        {
            var applied = await cobroRepository.AplicarAsync(id, cancellationToken);
            if (applied is null) return BadRequest(new { success = false, message = "No se pudo aplicar el pago a la factura." });
            cobro = applied;
        }
        else if (status != PaymentStatus.Applied && cobro.Status == PaymentStatus.Applied)
        {
            return Conflict(new { success = false, message = "Un cobro aplicado no puede revertirse desde este endpoint." });
        }
        if (status != PaymentStatus.Applied && !await cobroRepository.ActualizarEstadoAsync(id, status, cancellationToken)) return NotFound(new { success = false, message = "Cobro no encontrado." });
        cobro.Status = status;
        return Ok(new { success = true, message = "Estado de cobro actualizado.", data = MapCobro(cobro) });
    }

    private async Task<Factura?> ResolveFactura(RegistrarCobroRequest request, CancellationToken cancellationToken)
    {
        if (request.FacturaId.HasValue) return await facturaRepository.ObtenerPorIdAsync(request.FacturaId.Value, cancellationToken);
        if (request.InvoiceId.HasValue) return await facturaRepository.ObtenerPorIdAsync(request.InvoiceId.Value, cancellationToken);
        var number = FirstNonEmpty(request.NumFactura, request.InvoiceNumber);
        return string.IsNullOrWhiteSpace(number) ? null : await facturaRepository.ObtenerPorNumeroAsync(number, cancellationToken);
    }

    private async Task<HashSet<string>?> GetAllowedCustomerCodes(CancellationToken cancellationToken)
    {
        if (IsPrivileged()) return null;
        var customers = await clienteRepository.ObtenerTodosAsync(cancellationToken);
        if (IsCustomer())
        {
            var own = customers.FirstOrDefault(x => string.Equals(x.Dui, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || (CurrentUserId.HasValue && x.ProfileId == CurrentUserId));
            return own is null ? [] : [own.CodCliente];
        }
        var sellers = await GetAllowedSellerCodes(cancellationToken);
        return customers.Where(x => x.Vendedor is not null && sellers.Contains(x.Vendedor)).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
    }

    private async Task<bool> CanAccessCustomer(string code, CancellationToken cancellationToken)
    {
        var allowed = await GetAllowedCustomerCodes(cancellationToken);
        return allowed is null || allowed.Contains(code);
    }

    private async Task<HashSet<string>> GetAllowedSellerCodes(CancellationToken cancellationToken)
    {
        if (IsSellerScope()) return [CurrentUserCodVendedor ?? string.Empty];
        if (string.Equals(CurrentUserRole, "Supervisor", StringComparison.OrdinalIgnoreCase))
        {
            var users = await usuarioRepository.ObtenerTodosAsync(cancellationToken);
            return users.Where(x => string.Equals(x.SupervisadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase)).Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).Cast<string>().ToHashSet(StringComparer.OrdinalIgnoreCase);
        }
        return [];
    }

    private bool IsPrivileged() => CurrentUserRole is "Admin" or "Director" or "Gerente";
    private bool IsCustomer() => string.Equals(CurrentUserRole, "Cliente", StringComparison.OrdinalIgnoreCase);
    private bool IsSellerScope() => string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase);
    private static object MapCobro(Cobro x) => new { id = x.Id, invoiceId = x.FacturaId, invoiceNumber = x.NumFactura, customerId = x.CodCliente, customerName = x.CodCliente, amount = x.Monto, paymentMethod = x.MetodoPago.ToString().ToLowerInvariant(), reference = x.Referencia, receiptFileName = x.ComprobanteUrl, signatureDataUrl = x.FirmaUrl, date = x.CreatedAt, status = x.Status.ToString().ToLowerInvariant() };
    private static string? FirstNonEmpty(params string?[] values) => values.FirstOrDefault(x => !string.IsNullOrWhiteSpace(x))?.Trim();
    private static PaymentMethod? ParsePaymentMethod(string? value) => string.IsNullOrWhiteSpace(value) ? PaymentMethod.Transferencia : value.Trim().ToLowerInvariant() switch { "efectivo" or "cash" or "1" => PaymentMethod.Efectivo, "transferencia" or "transfer" or "2" => PaymentMethod.Transferencia, "cheque" or "check" or "3" => PaymentMethod.Cheque, _ => null };
}

public sealed class RegistrarCobroRequest
{
    public Guid? Id { get; set; } public Guid? FacturaId { get; set; } public Guid? InvoiceId { get; set; } public string? NumFactura { get; set; } public string? InvoiceNumber { get; set; } public string? CodCliente { get; set; } public string? CustomerId { get; set; } public string? CodVendedor { get; set; } public decimal? Monto { get; set; } public decimal? Amount { get; set; } public string? MetodoPago { get; set; } public string? PaymentMethod { get; set; } public string? Referencia { get; set; } public string? Reference { get; set; } public string? ComprobanteUrl { get; set; } public string? ReceiptFileName { get; set; } public string? ReceiptContentBase64 { get; set; } public string? FirmaUrl { get; set; } public string? SignatureDataUrl { get; set; } public string? Notas { get; set; }
}

public sealed class ActualizarCobroEstadoRequest { public string Status { get; set; } = string.Empty; }
