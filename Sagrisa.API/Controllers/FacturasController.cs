using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;
using System.Globalization;
using System.Text;

namespace Sagrisa.API.Controllers;

[Authorize]
[Route("api/invoices")]
public sealed class FacturasController(
    IFacturaRepository facturaRepository,
    IClienteRepository clienteRepository,
    IPedidoRepository pedidoRepository,
    IUsuarioRepository usuarioRepository) : SagrisaBaseController
{
    [HttpGet]
    public async Task<IActionResult> Obtener([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 200, [FromQuery] string? codCliente = null, CancellationToken cancellationToken = default)
    {
        var allowed = await GetAllowedCustomerCodes(cancellationToken);
        var items = (await facturaRepository.ObtenerTodosAsync(cancellationToken)).Where(x => allowed is null || allowed.Contains(x.CodCliente));
        if (!string.IsNullOrWhiteSpace(codCliente)) items = items.Where(x => x.CodCliente.Equals(codCliente.Trim(), StringComparison.OrdinalIgnoreCase));
        var size = Math.Clamp(pageSize, 1, 500);
        var data = items.OrderByDescending(x => x.FechaEmision).Skip((Math.Max(1, pageNumber) - 1) * size).Take(size).Select(MapSummary).ToList();
        return Ok(new { success = true, message = "Facturas obtenidas.", data });
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> ObtenerDetalle(string id, CancellationToken cancellationToken)
    {
        Factura? factura = Guid.TryParse(id, out var guid) ? await facturaRepository.ObtenerPorIdAsync(guid, cancellationToken) : await facturaRepository.ObtenerPorNumeroAsync(id, cancellationToken);
        if (factura is null || !await CanAccessCustomer(factura.CodCliente, cancellationToken)) return NotFound(new { success = false, message = "Factura no encontrada." });
        var cliente = await clienteRepository.ObtenerPorCodigoAsync(factura.CodCliente, cancellationToken);
        var pedido = factura.OrderId.HasValue ? await pedidoRepository.ObtenerPorIdAsync(factura.OrderId.Value, cancellationToken) : null;
        var items = pedido is null ? Array.Empty<object>() : pedido.Detalles.Select(x => (object)new { name = x.NomProducto, quantity = x.Cantidad, price = x.PrecioUnitario }).ToArray();
        var data = new { id = factura.Id, number = factura.NumFactura, date = factura.FechaEmision.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture), total = factura.TotalFactura, balance = factura.Saldo, status = MapStatus(factura), orderNumber = pedido?.NumPedido ?? string.Empty, dueDate = factura.FechaVencimiento.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture), customer = new { name = cliente?.NomCliente ?? factura.CodCliente, id = factura.CodCliente }, items, delivery = new { address = pedido?.DireccionEntrega ?? string.Empty, notes = pedido?.Observacion ?? string.Empty } };
        return Ok(new { success = true, message = "Factura obtenida.", data });
    }

    [HttpGet("{id}/pdf")]
    public async Task<IActionResult> DescargarPdf(string id, CancellationToken cancellationToken)
    {
        Factura? factura = Guid.TryParse(id, out var guid) ? await facturaRepository.ObtenerPorIdAsync(guid, cancellationToken) : await facturaRepository.ObtenerPorNumeroAsync(id, cancellationToken);
        if (factura is null || !await CanAccessCustomer(factura.CodCliente, cancellationToken)) return NotFound(new { success = false, message = "Factura no encontrada." });
        var content = $"SAGRISA - FACTURA {factura.NumFactura}\nCliente: {factura.CodCliente}\nTotal: {factura.TotalFactura:0.00}\nSaldo: {factura.Saldo:0.00}";
        return File(BuildPdf(content), "application/pdf", $"SAGRISA_factura_{factura.NumFactura}.pdf");
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
        if (string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase)) return [CurrentUserCodVendedor ?? string.Empty];
        if (string.Equals(CurrentUserRole, "Supervisor", StringComparison.OrdinalIgnoreCase))
        {
            var users = await usuarioRepository.ObtenerTodosAsync(cancellationToken);
            return users.Where(x => string.Equals(x.SupervisadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase)).Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).Cast<string>().ToHashSet(StringComparer.OrdinalIgnoreCase);
        }
        return [];
    }

    private bool IsPrivileged() => CurrentUserRole is "Admin" or "Director" or "Gerente";
    private bool IsCustomer() => string.Equals(CurrentUserRole, "Cliente", StringComparison.OrdinalIgnoreCase);
    private static object MapSummary(Factura factura) => new { id = factura.Id, number = factura.NumFactura, date = factura.FechaEmision.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture), total = factura.TotalFactura, balance = factura.Saldo, status = MapStatus(factura) };
    private static string MapStatus(Factura factura) => factura.Saldo <= 0 || factura.Status == InvoiceStatus.Paid ? "paid" : factura.FechaVencimiento.Date < DateTime.UtcNow.Date ? "overdue" : "pending";

    private static byte[] BuildPdf(string text)
    {
        var escaped = text.Replace("\\", "\\\\").Replace("(", "\\(").Replace(")", "\\)").Replace("\n", ") Tj T* (");
        var objects = new[] { "<< /Type /Catalog /Pages 2 0 R >>", "<< /Type /Pages /Kids [3 0 R] /Count 1 >>", "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>", "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>", $"<< /Length {escaped.Length + 45} >>\nstream\nBT /F1 11 Tf 50 740 Td 14 TL ({escaped}) Tj ET\nendstream" };
        using var stream = new MemoryStream(); using var writer = new StreamWriter(stream, Encoding.ASCII, 1024, true); writer.Write("%PDF-1.4\n"); writer.Flush(); var offsets = new List<long> { 0 };
        foreach (var (value, index) in objects.Select((value, index) => (value, index))) { offsets.Add(stream.Position); writer.Write($"{index + 1} 0 obj\n{value}\nendobj\n"); writer.Flush(); }
        var xref = stream.Position; writer.Write($"xref\n0 {objects.Length + 1}\n0000000000 65535 f \n"); foreach (var offset in offsets.Skip(1)) writer.Write($"{offset:0000000000} 00000 n \n"); writer.Write($"trailer\n<< /Size {objects.Length + 1} /Root 1 0 R >>\nstartxref\n{xref}\n%%EOF"); writer.Flush(); return stream.ToArray();
    }
}
