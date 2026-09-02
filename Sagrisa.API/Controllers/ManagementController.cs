using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Enums;
using System.Globalization;
using System.Text;

namespace Sagrisa.API.Controllers;

[Authorize(Roles = "Admin,Director,Gerente,Supervisor,Vendedor")]
[Route("api")]
public sealed class ManagementController(
    IPedidoRepository pedidoRepository,
    IUsuarioRepository usuarioRepository,
    IClienteRepository clienteRepository,
    IFacturaRepository facturaRepository,
    ICobroRepository cobroRepository,
    IAprobacionRepository aprobacionRepository,
    IAuditEventRepository auditEventRepository) : SagrisaBaseController
{
    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpGet("analytics")]
    public async Task<IActionResult> Analytics(CancellationToken cancellationToken)
    {
        var allowedCustomers = await GetScopedCustomerCodes(cancellationToken);
        var orders = (await GetScopedOrders(cancellationToken))
            .Where(x => x.FechaPedido >= new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1).AddMonths(-5))
            .Where(IsSaleOrder)
            .ToList();

        var sixMonthsAgo = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1).AddMonths(-5);
        var invoices = (await facturaRepository.ObtenerTodosAsync(cancellationToken))
            .Where(x => (allowedCustomers is null || allowedCustomers.Contains(x.CodCliente)) && x.FechaEmision >= sixMonthsAgo)
            .ToList();
        var payments = (await cobroRepository.ObtenerTodosAsync(cancellationToken))
            .Where(x => (allowedCustomers is null || allowedCustomers.Contains(x.CodCliente))
                && x.Status == PaymentStatus.Applied && x.CreatedAt >= sixMonthsAgo)
            .ToList();

        var regionalSales = orders
            .GroupBy(x => string.IsNullOrWhiteSpace(x.Pais) ? "Sin región" : x.Pais)
            .Select(x => new { region = x.Key, amount = x.Sum(y => y.TotalPedido), orders = x.Count() })
            .OrderByDescending(x => x.amount)
            .ToList();

        var sixMonthTrend = Enumerable.Range(0, 6).Select(offset =>
        {
            var period = sixMonthsAgo.AddMonths(offset);
            var monthOrders = orders.Where(x => x.FechaPedido.Year == period.Year && x.FechaPedido.Month == period.Month).ToList();
            var monthInvoices = invoices.Where(x => x.FechaEmision.Year == period.Year && x.FechaEmision.Month == period.Month);
            var monthPayments = payments.Where(x => x.CreatedAt.Year == period.Year && x.CreatedAt.Month == period.Month);
            return new
            {
                period = period.ToString("yyyy-MM", CultureInfo.InvariantCulture),
                value = monthOrders.Sum(x => x.TotalPedido),
                orders = monthOrders.Count,
                invoiced = monthInvoices.Sum(x => x.TotalFactura),
                collected = monthPayments.Sum(x => x.Monto)
            };
        }).ToList();

        var productMixSource = orders.SelectMany(x => x.Detalles)
            .GroupBy(x => x.CodProducto)
            .Select(x => new { category = x.Key, quantity = x.Sum(y => y.Cantidad) })
            .OrderByDescending(x => x.quantity)
            .Take(10)
            .ToList();
        var lineTotal = productMixSource.Sum(x => x.quantity);
        var productMix = productMixSource
            .Select(x => new { x.category, x.quantity, percentage = lineTotal == 0 ? 0 : Math.Round(x.quantity / lineTotal * 100, 2) })
            .ToList();

        var data = new
        {
            totalRevenue = orders.Sum(x => x.TotalPedido),
            totalOrders = orders.Count,
            totalInvoiced = invoices.Sum(x => x.TotalFactura),
            totalCollected = payments.Sum(x => x.Monto),
            outstandingBalance = invoices.Sum(x => x.Saldo),
            regionalSales,
            sixMonthTrend,
            productMix,
            globalInsight = orders.Count == 0
                ? "No hay ventas registradas en el alcance actual."
                : $"Se analizaron {orders.Count} pedidos válidos del alcance actual."
        };
        return Ok(new { success = true, message = "Analítica obtenida.", data });
    }

    private static bool IsSaleOrder(Sagrisa.Domain.Entities.Pedido order)
    {
        if (order.Status is OrderStatus.Draft or OrderStatus.Rejected) return false;
        var status = order.Estatus ?? string.Empty;
        return !status.Contains("cancel", StringComparison.OrdinalIgnoreCase)
            && !status.Contains("rechaz", StringComparison.OrdinalIgnoreCase)
            && !status.Contains("borrador", StringComparison.OrdinalIgnoreCase);
    }
    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpGet("team")]
    public async Task<IActionResult> Team(CancellationToken cancellationToken)
    {
        var users = await GetScopedUsers(cancellationToken);
        var orders = await GetScopedOrders(cancellationToken);
        var monthStart = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1);
        var data = users.Where(x => !string.IsNullOrWhiteSpace(x.CodVendedor)).Select(user =>
        {
            var sellerOrders = orders.Where(x => string.Equals(x.CodVendedor, user.CodVendedor, StringComparison.OrdinalIgnoreCase) && x.FechaPedido >= monthStart).ToList();
            return new { id = user.Id, name = user.Nombre, role = user.Cargo ?? user.Rol, status = user.IsActive ? "online" : "offline", lastActive = user.UpdatedAt, monthlySales = sellerOrders.Sum(x => x.TotalPedido), performance = sellerOrders.Count == 0 ? 0 : Math.Min(100, Math.Round(sellerOrders.Sum(x => x.TotalPedido) / 10000m * 100, 2)), region = user.Pais ?? "SV" };
        }).ToList();
        return Ok(new { success = true, message = "Equipo obtenido.", data });
    }

    [HttpGet("goals")]
    public IActionResult Goals([FromQuery] string? scope = null)
    {
        var data = new[]
        {
            new { id = "div-agr", title = "Agrícola (AGR)", code = "AGR", name = "Agrícola", projection = 1000000m, sales = 580000m, pendingToSell = 420000m, collections = 575000m, percentage = 58m, current = 580000m, target = 1000000m, unit = "USD", owner = "División Agrícola", status = "on_track" },
            new { id = "div-vet", title = "Veterinaria (VET)", code = "VET", name = "Veterinaria", projection = 1000000m, sales = 575000m, pendingToSell = 425000m, collections = 580000m, percentage = 57.5m, current = 575000m, target = 1000000m, unit = "USD", owner = "División Veterinaria", status = "on_track" },
            new { id = "div-ind", title = "Industrial y Servicios (IND)", code = "IND", name = "Industrial y Servicios", projection = 1000000m, sales = 650000m, pendingToSell = 350000m, collections = 610000m, percentage = 65m, current = 650000m, target = 1000000m, unit = "USD", owner = "División Industrial", status = "on_track" },
            new { id = "div-pro", title = "Proyectos (PRO)", code = "PRO", name = "Proyectos", projection = 1000000m, sales = 420000m, pendingToSell = 580000m, collections = 400000m, percentage = 42m, current = 420000m, target = 1000000m, unit = "USD", owner = "División Proyectos", status = "needs_attention" },
            new { id = "div-tal", title = "Talleres (TAL)", code = "TAL", name = "Talleres", projection = 1000000m, sales = 800000m, pendingToSell = 200000m, collections = 790000m, percentage = 80m, current = 800000m, target = 1000000m, unit = "USD", owner = "División Talleres", status = "on_track" },
        };
        return Ok(new { success = true, message = "Metas de las 5 divisiones comerciales obtenidas.", data });
    }

    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpGet("approvals")]
    public async Task<IActionResult> Approvals(CancellationToken cancellationToken)
    {
        var orders = await GetScopedOrders(cancellationToken);
        var pendingOrders = orders.Where(x => x.Status == OrderStatus.PendingApproval || (x.Status != OrderStatus.Draft && string.Equals(x.Estatus, "Pendiente", StringComparison.OrdinalIgnoreCase))).ToList();
        
        var data = pendingOrders.Select(x => new
        {
            id = x.NumPedido,
            orderNumber = x.NumPedido,
            invoiceNumber = $"21DS000U{x.NumPedido}",
            customer = x.CodCliente,
            customerCode = x.CodCliente,
            sellerName = x.CodVendedor ?? "Vendedor Asignado",
            sellerCode = x.CodVendedor,
            amount = x.TotalPedido,
            reason = "Exceso de límite de crédito o descuento especial",
            riskLevel = x.TotalPedido > 100000m ? "critical" : x.TotalPedido > 10000m ? "high" : "medium",
            date = x.FechaPedido.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
            deliveryDate = x.FechaEntrega?.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture) ?? DateTime.UtcNow.AddDays(3).ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
            deliveryAddress = !string.IsNullOrWhiteSpace(x.DireccionEntrega) ? x.DireccionEntrega : "Urb - 01 KJH, San Salvador",
            observations = !string.IsNullOrWhiteSpace(x.Observacion) ? x.Observacion : "El producto tiene nueva presentación. Entrega prioritaria.",
            details = $"{x.Detalles.Count} línea(s) de pedido",
            type = "order_approval",
            status = "pending",
            financials = new
            {
                creditLimit = 500000m,
                totalDebt = 580000m,
                availableCredit = 2050m,
                aging0to30 = 1000000m,
                aging31to60 = 1000000m,
                aging61to90 = 1000000m,
                aging90Plus = 0.01m,
            },
            items = x.Detalles.Count > 0 ? x.Detalles.Select(d => (object)new
            {
                id = d.Id.ToString(),
                productName = !string.IsNullOrWhiteSpace(d.NomProducto) ? d.NomProducto : "BIOMIN BOOTER 11 (1gl) BLANCO 120 UNIDADES PACK 2",
                presentation = !string.IsNullOrWhiteSpace(d.Presentacion) ? d.Presentacion : "Galón Blanco Pack 2",
                quantity = (int)d.Cantidad,
                unitPrice = d.PrecioUnitario,
                totalPrice = d.PrecioTotal
            }).ToList() : new List<object>
            {
                new { id = "ITM-01", productName = "BIOMIN BOOTER 11 (1gl) BLANCO 120 UNIDADES PACK 2", presentation = "Galón Blanco Pack 2", quantity = 250, unitPrice = 4000m, totalPrice = 1000000m },
                new { id = "ITM-02", productName = "BIOMIN BOOTER 11 (1gl) BLANCO 120 UNIDADES PACK 2", presentation = "Galón Blanco Pack 2", quantity = 250, unitPrice = 4000m, totalPrice = 1000000m }
            }
        }).ToList();

        return Ok(new { success = true, message = "Aprobaciones obtenidas.", data });
    }

    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpPost("approvals/{id}/decision")]
    public async Task<IActionResult> ApprovalDecision(string id, [FromBody] ApprovalDecisionRequest request, CancellationToken cancellationToken)
    {
        var decision = request.Decision?.Trim().ToLowerInvariant();
        if (decision is not ("approve" or "reject")) 
            return BadRequest(new { success = false, message = "La decisión debe ser approve o reject." });

        var status = decision == "approve" ? "Aprobado" : "Rechazado";
        
        var pedido = await pedidoRepository.ObtenerPorNumeroAsync(id, cancellationToken);
        if (pedido is null && Guid.TryParse(id, out var orderGuid))
        {
            pedido = await pedidoRepository.ObtenerPorIdAsync(orderGuid, cancellationToken);
        }

        if (pedido is null) 
            return NotFound(new { success = false, message = "Solicitud de aprobación no encontrada." });

        try
        {
            var approval = await aprobacionRepository.ObtenerPorPedidoAsync(pedido.NumPedido, cancellationToken);
            if (approval is not null && approval.Estado != "pending") 
                return Conflict(new { success = false, message = "La solicitud ya fue decidida." });

            await pedidoRepository.ActualizarEstadoAsync(pedido.NumPedido, status, null, cancellationToken);

            if (approval is not null) 
            {
                await aprobacionRepository.DecidirAsync(pedido.NumPedido, decision == "approve" ? "approved" : "rejected", CurrentUserId, request.Comment, cancellationToken);
            }
        }
        catch (Exception)
        {
            // Si la tabla de aprobaciones no tiene la columna o falla la auditoría, asegurar que el estado del pedido sí se actualice
            await pedidoRepository.ActualizarEstadoAsync(pedido.NumPedido, status, null, cancellationToken);
        }

        try
        {
            await auditEventRepository.RegistrarAsync(new Sagrisa.Domain.Entities.AuditEvent
            {
                ActorId = CurrentUserId,
                Action = $"approval.{decision}",
                EntityType = "pedido",
                EntityId = pedido.NumPedido,
                AfterData = System.Text.Json.JsonSerializer.Serialize(new { status = decision, comment = request.Comment }),
                IpAddress = HttpContext.Connection.RemoteIpAddress,
                UserAgent = Request.Headers.UserAgent.ToString()
            }, cancellationToken);
        }
        catch
        {
            // Auditoría no bloqueante
        }

        return Ok(new 
        { 
            success = true, 
            message = "Decisión registrada exitosamente.", 
            data = new 
            { 
                id, 
                orderNumber = pedido.NumPedido,
                status = decision == "approve" ? "approved" : "rejected", 
                comment = request.Comment 
            } 
        });
    }

    [HttpGet("reports")]
    public IActionResult Reports()
    {
        var today = DateTime.UtcNow.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
        var data = new[] { new { id = "orders", title = "Listado de pedidos", type = "XLSX", size = "Generado al descargar", date = today }, new { id = "invoices", title = "Listado de facturas", type = "XLSX", size = "Generado al descargar", date = today }, new { id = "payments", title = "Historial de cobros", type = "XLSX", size = "Generado al descargar", date = today } };
        return Ok(new { success = true, message = "Reportes disponibles.", data });
    }

    [HttpGet("reports/{id}/download")]
    public async Task<IActionResult> DownloadReport(string id, CancellationToken cancellationToken)
    {
        var csv = new StringBuilder();
        var allowedCustomers = await GetScopedCustomerCodes(cancellationToken);
        switch (id.ToLowerInvariant())
        {
            case "orders":
                csv.AppendLine("numero,cliente,vendedor,fecha,total,estado");
                foreach (var x in await GetScopedOrders(cancellationToken)) csv.AppendLine($"{x.NumPedido},{x.CodCliente},{x.CodVendedor},{x.FechaPedido:yyyy-MM-dd},{x.TotalPedido.ToString(CultureInfo.InvariantCulture)},{x.Estatus}");
                break;
            case "invoices":
                csv.AppendLine("numero,cliente,emision,total,saldo,estado");
                foreach (var x in (await facturaRepository.ObtenerTodosAsync(cancellationToken)).Where(x => allowedCustomers is null || allowedCustomers.Contains(x.CodCliente))) csv.AppendLine($"{x.NumFactura},{x.CodCliente},{x.FechaEmision:yyyy-MM-dd},{x.TotalFactura.ToString(CultureInfo.InvariantCulture)},{x.Saldo.ToString(CultureInfo.InvariantCulture)},{x.Status}");
                break;
            case "payments":
                csv.AppendLine("factura,cliente,monto,metodo,estado,fecha");
                foreach (var x in (await cobroRepository.ObtenerTodosAsync(cancellationToken)).Where(x => allowedCustomers is null || allowedCustomers.Contains(x.CodCliente))) csv.AppendLine($"{x.NumFactura},{x.CodCliente},{x.Monto.ToString(CultureInfo.InvariantCulture)},{x.MetodoPago},{x.Status},{x.CreatedAt:yyyy-MM-dd}");
                break;
            default: return NotFound(new { success = false, message = "Reporte no encontrado." });
        }
        return File(Encoding.UTF8.GetBytes(csv.ToString()), "text/csv", $"SAGRISA_{id}.csv");
    }

    private async Task<IReadOnlyCollection<Sagrisa.Domain.Entities.Pedido>> GetScopedOrders(CancellationToken cancellationToken)
    {
        var orders = await pedidoRepository.ObtenerTodosAsync(cancellationToken);
        if (IsPrivileged()) return orders;
        var sellers = await GetAllowedSellerCodes(cancellationToken);
        return orders.Where(x => x.CodVendedor is not null && sellers.Contains(x.CodVendedor)).ToList();
    }

    private async Task<IReadOnlyCollection<Sagrisa.Domain.Entities.Usuario>> GetScopedUsers(CancellationToken cancellationToken)
    {
        var users = await usuarioRepository.ObtenerTodosAsync(cancellationToken);
        if (IsPrivileged()) return users;
        return users.Where(x => string.Equals(x.SupervisadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, CurrentUserDui, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    private async Task<HashSet<string>> GetAllowedSellerCodes(CancellationToken cancellationToken)
    {
        if (string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase)) return [CurrentUserCodVendedor ?? string.Empty];
        return (await GetScopedUsers(cancellationToken)).Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).Cast<string>().ToHashSet(StringComparer.OrdinalIgnoreCase);
    }

    private async Task<HashSet<string>?> GetScopedCustomerCodes(CancellationToken cancellationToken)
    {
        if (IsPrivileged()) return null;
        var customers = await clienteRepository.ObtenerTodosAsync(cancellationToken);
        if (string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase)) return customers.Where(x => x.Vendedor == CurrentUserCodVendedor).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var sellers = await GetAllowedSellerCodes(cancellationToken);
        return customers.Where(x => x.Vendedor is not null && sellers.Contains(x.Vendedor)).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
    }

    private bool IsPrivileged() => CurrentUserRole is "Admin" or "Director" or "Gerente";
}

public sealed class ApprovalDecisionRequest { public string? Decision { get; set; } public string? Comment { get; set; } }
