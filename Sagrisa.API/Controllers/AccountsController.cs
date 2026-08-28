using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Enums;
using System.Globalization;
using System.Text;

namespace Sagrisa.API.Controllers;

[Authorize]
[Route("api/accounts/me")]
public sealed class AccountsController(
    IFacturaRepository facturaRepository,
    IPedidoRepository pedidoRepository,
    IClienteRepository clienteRepository,
    ICobroRepository cobroRepository,
    IUsuarioRepository usuarioRepository) : SagrisaBaseController
{
    [HttpGet]
    public async Task<IActionResult> ObtenerResumen([FromQuery] string? codCliente = null, CancellationToken cancellationToken = default)
    {
        var scope = await ResolveCustomerScope(codCliente, cancellationToken);
        if (scope is null) return Forbid();
        var data = await BuildSummary(scope, cancellationToken);
        return Ok(new { success = true, message = "Estado de cuenta obtenido.", data });
    }

    [HttpGet("summary")]
    public Task<IActionResult> Resumen([FromQuery] string? codCliente = null, CancellationToken cancellationToken = default) => ObtenerResumen(codCliente, cancellationToken);

    [HttpGet("overdue-invoices")]
    public async Task<IActionResult> ObtenerVencidas([FromQuery] string? codCliente = null, CancellationToken cancellationToken = default)
    {
        var scope = await ResolveCustomerScope(codCliente, cancellationToken);
        if (scope is null) return Forbid();
        var facturas = (await facturaRepository.ObtenerPaginadoAsync(1, 500, scope, cancellationToken)).Items;
        var today = DateTime.UtcNow.Date;
        var data = facturas.Where(x => x.Saldo > 0 && x.FechaVencimiento.Date < today).Select(x => { var days = (today - x.FechaVencimiento.Date).Days; return new { id = x.Id, number = x.NumFactura, customerName = x.CodCliente, amount = x.Saldo, daysOverdue = days, status = days > 60 ? "critical" : "warning" }; }).ToList();
        return Ok(new { success = true, message = "Facturas vencidas obtenidas.", data });
    }

    [HttpPost("statement/email")]
    public IActionResult EnviarPorEmail([FromBody] SendStatementRequest request)
        => Ok(new { success = true, message = string.IsNullOrWhiteSpace(request.Email) ? "Estado de cuenta generado." : $"Estado de cuenta preparado para {request.Email}." });

    [HttpGet("statement/pdf")]
    public async Task<IActionResult> DescargarEstadoCuenta([FromQuery] string? codCliente = null, CancellationToken cancellationToken = default)
    {
        var scope = await ResolveCustomerScope(codCliente, cancellationToken);
        if (scope is null) return Forbid();
        var data = await BuildSummary(scope, cancellationToken);
        var content = $"SAGRISA - ESTADO DE CUENTA\nCliente: {scope}\nTotal adeudado: {data.TotalDebt:0.00}\nFacturas pendientes: {data.PendingInvoices}";
        return File(BuildPdf(content), "application/pdf", "SAGRISA_estado_de_cuenta.pdf");
    }

    private async Task<string?> ResolveCustomerScope(string? requested, CancellationToken cancellationToken)
    {
        var customers = await clienteRepository.ObtenerTodosAsync(cancellationToken);
        if (string.Equals(CurrentUserRole, "Cliente", StringComparison.OrdinalIgnoreCase))
        {
            var own = customers.FirstOrDefault(x => string.Equals(x.Dui, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || (CurrentUserId.HasValue && x.ProfileId == CurrentUserId));
            return own?.CodCliente;
        }
        if (!string.IsNullOrWhiteSpace(requested))
        {
            if (IsPrivileged()) return requested.Trim();
            var allowed = await AllowedCustomerCodes(customers, cancellationToken);
            return allowed.Contains(requested.Trim()) ? requested.Trim() : null;
        }
        return IsPrivileged() ? null : null;
    }

    private async Task<HashSet<string>> AllowedCustomerCodes(IReadOnlyCollection<Sagrisa.Domain.Entities.Cliente> customers, CancellationToken cancellationToken)
    {
        if (string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase)) return customers.Where(x => x.Vendedor == CurrentUserCodVendedor).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var users = await usuarioRepository.ObtenerTodosAsync(cancellationToken);
        var sellers = users.Where(x => string.Equals(x.SupervisadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase)).Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).Cast<string>().ToHashSet(StringComparer.OrdinalIgnoreCase);
        return customers.Where(x => x.Vendedor is not null && sellers.Contains(x.Vendedor)).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
    }

    private async Task<AccountSummary> BuildSummary(string? codCliente, CancellationToken cancellationToken)
    {
        var facturas = (await facturaRepository.ObtenerPaginadoAsync(1, 500, codCliente, cancellationToken)).Items;
        var pedidos = (await pedidoRepository.ObtenerPaginadoAsync(1, 500, null, codCliente, cancellationToken)).Items;
        var cliente = string.IsNullOrWhiteSpace(codCliente) ? null : await clienteRepository.ObtenerPorCodigoAsync(codCliente, cancellationToken);
        var pagos = (await cobroRepository.ObtenerPaginadoAsync(1, 500, codCliente, null, cancellationToken)).Items.Where(x => x.Status == PaymentStatus.Applied).OrderByDescending(x => x.CreatedAt).ToList();
        var today = DateTime.UtcNow.Date;
        var overdue = facturas.Where(x => x.Saldo > 0 && x.FechaVencimiento.Date < today).ToList();
        var aging = new[] { new AgingItem("Actual", facturas.Where(x => x.Saldo > 0 && x.FechaVencimiento.Date >= today).Sum(x => x.Saldo)), new AgingItem("1-30 días", overdue.Where(x => (today - x.FechaVencimiento.Date).Days <= 30).Sum(x => x.Saldo)), new AgingItem("31-60 días", overdue.Where(x => { var d = (today - x.FechaVencimiento.Date).Days; return d > 30 && d <= 60; }).Sum(x => x.Saldo)), new AgingItem("+60 días", overdue.Where(x => (today - x.FechaVencimiento.Date).Days > 60).Sum(x => x.Saldo)) };
        var totalDebt = facturas.Sum(x => Math.Max(0, x.Saldo));
        return new AccountSummary(totalDebt, Math.Max(0, (cliente?.MontoCredito ?? 0) - totalDebt), facturas.Count(x => x.Saldo > 0), pedidos.Count(x => !string.Equals(x.Estatus, "Entregado", StringComparison.OrdinalIgnoreCase)), 0, 0, pagos.FirstOrDefault()?.Monto ?? 0, pagos.FirstOrDefault()?.CreatedAt.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) ?? string.Empty, cliente?.MontoCredito ?? 0, aging);
    }

    private bool IsPrivileged() => CurrentUserRole is "Admin" or "Director" or "Gerente";
    private static byte[] BuildPdf(string text)
    {
        var escaped = text.Replace("\\", "\\\\").Replace("(", "\\(").Replace(")", "\\)").Replace("\n", ") Tj T* (");
        var objects = new[] { "<< /Type /Catalog /Pages 2 0 R >>", "<< /Type /Pages /Kids [3 0 R] /Count 1 >>", "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>", "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>", $"<< /Length {escaped.Length + 45} >>\nstream\nBT /F1 11 Tf 50 740 Td 14 TL ({escaped}) Tj ET\nendstream" };
        using var stream = new MemoryStream(); using var writer = new StreamWriter(stream, Encoding.ASCII, 1024, true); writer.Write("%PDF-1.4\n"); writer.Flush(); var offsets = new List<long> { 0 };
        foreach (var (value, index) in objects.Select((value, index) => (value, index))) { offsets.Add(stream.Position); writer.Write($"{index + 1} 0 obj\n{value}\nendobj\n"); writer.Flush(); }
        var xref = stream.Position; writer.Write($"xref\n0 {objects.Length + 1}\n0000000000 65535 f \n"); foreach (var offset in offsets.Skip(1)) writer.Write($"{offset:0000000000} 00000 n \n"); writer.Write($"trailer\n<< /Size {objects.Length + 1} /Root 1 0 R >>\nstartxref\n{xref}\n%%EOF"); writer.Flush(); return stream.ToArray();
    }
    private sealed record AgingItem(string Range, decimal Amount);
    private sealed record AccountSummary(decimal TotalDebt, decimal AvailableCredit, int PendingInvoices, int OpenOrders, int DaysToPay, int CreditTerm, decimal LastPayment, string LastPaymentDate, decimal CreditLine, AgingItem[] Aging);
}

public sealed class SendStatementRequest { public string? Email { get; set; } }
