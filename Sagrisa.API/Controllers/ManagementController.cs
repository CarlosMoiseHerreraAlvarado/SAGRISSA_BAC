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
    IAuditEventRepository auditEventRepository,
    IMetaRepository metaRepository) : SagrisaBaseController
{
    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpGet("analytics")]
    public async Task<IActionResult> Analytics([FromQuery] string? area = null, CancellationToken cancellationToken = default)
    {
        string? effectiveArea = area;
        if (string.IsNullOrWhiteSpace(effectiveArea) && string.Equals(CurrentUserRole, "Gerente", StringComparison.OrdinalIgnoreCase))
        {
            effectiveArea = CurrentUserDivision;
        }

        var allowedCustomers = await GetScopedCustomerCodes(cancellationToken);
        var orders = (await GetScopedOrders(cancellationToken, effectiveArea))
            .Where(x => x.FechaPedido >= new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1).AddMonths(-5))
            .Where(IsSaleOrder)
            .ToList();

        var sixMonthsAgo = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1).AddMonths(-5);
        var areaCustomerCodes = !string.IsNullOrWhiteSpace(effectiveArea)
            ? orders.Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase)
            : null;

        var allInvoices = (await facturaRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var invoices = allInvoices
            .Where(x => (allowedCustomers is null || allowedCustomers.Contains(x.CodCliente)) &&
                        (areaCustomerCodes is null || areaCustomerCodes.Contains(x.CodCliente)) &&
                        x.FechaEmision >= sixMonthsAgo)
            .ToList();

        var allPayments = (await cobroRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var payments = allPayments
            .Where(x => (allowedCustomers is null || allowedCustomers.Contains(x.CodCliente)) &&
                        (areaCustomerCodes is null || areaCustomerCodes.Contains(x.CodCliente)) &&
                        x.Status == PaymentStatus.Applied && x.CreatedAt >= sixMonthsAgo)
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

        var productMixSource = orders.SelectMany(x => x.Detalles ?? [])
            .GroupBy(x => x.CodProducto)
            .Select(x => new { category = x.Key, quantity = x.Sum(y => y.Cantidad) })
            .OrderByDescending(x => x.quantity)
            .Take(10)
            .ToList();
        var lineTotal = productMixSource.Sum(x => x.quantity);
        var productMix = productMixSource
            .Select(x => new { x.category, x.quantity, percentage = lineTotal == 0 ? 0 : Math.Round(x.quantity / lineTotal * 100, 2) })
            .ToList();

        var allScopedUsers = await GetScopedUsers(cancellationToken, effectiveArea);
        var distinctAreas = allScopedUsers
            .Where(u => !string.IsNullOrWhiteSpace(u.Division))
            .Select(u => u.Division!)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        var data = new
        {
            totalRevenue = orders.Sum(x => x.TotalPedido),
            totalOrders = orders.Count,
            totalInvoiced = invoices.Sum(x => x.TotalFactura),
            totalCollected = payments.Sum(x => x.Monto),
            outstandingBalance = invoices.Sum(x => x.Saldo),
            areasReportadas = distinctAreas.Count,
            areaFiltro = effectiveArea,
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
    public async Task<IActionResult> Team(
        [FromQuery] string? vendedor = null,
        [FromQuery] string? area = null,
        CancellationToken cancellationToken = default)
    {
        string? effectiveArea = area;
        if (string.IsNullOrWhiteSpace(effectiveArea) && string.Equals(CurrentUserRole, "Gerente", StringComparison.OrdinalIgnoreCase))
        {
            effectiveArea = CurrentUserDivision;
        }

        var users = (await GetScopedUsers(cancellationToken, effectiveArea)).ToList();
        if (!string.IsNullOrWhiteSpace(vendedor))
        {
            var q = vendedor.Trim();
            users = users.Where(u =>
                (u.CodVendedor != null && u.CodVendedor.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                (u.Nombre != null && u.Nombre.Contains(q, StringComparison.OrdinalIgnoreCase))
            ).ToList();
        }

        var orders = await GetScopedOrders(cancellationToken, effectiveArea);
        var monthStart = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1);
        var data = users.Where(x => !string.IsNullOrWhiteSpace(x.CodVendedor)).Select(user =>
        {
            var sellerOrders = orders.Where(x => string.Equals(x.CodVendedor, user.CodVendedor, StringComparison.OrdinalIgnoreCase) && x.FechaPedido >= monthStart).ToList();
            var sales = sellerOrders.Sum(x => x.TotalPedido);
            var projection = 25000m;
            var perf = projection > 0 ? Math.Round(sales / projection * 100, 2) : 0m;

            return new
            {
                id = user.Id,
                name = user.Nombre,
                code = user.CodVendedor,
                role = user.Cargo ?? user.Rol,
                status = user.IsActive ? "online" : "offline",
                lastActive = user.UpdatedAt,
                monthlySales = sales,
                performance = perf,
                region = user.Pais ?? string.Empty,
                division = user.Division ?? string.Empty
            };
        }).ToList();

        return Ok(new { success = true, message = "Equipo obtenido.", data });
    }

    [HttpGet("goals")]
    public async Task<IActionResult> Goals(
        [FromQuery] string? scope = null,
        [FromQuery] string? vendedor = null,
        [FromQuery] string? periodo = null,
        [FromQuery] string? valor = null,
        [FromQuery] string? area = null,
        CancellationToken cancellationToken = default)
    {
        string? effectiveArea = area;
        if (string.IsNullOrWhiteSpace(effectiveArea) && string.Equals(CurrentUserRole, "Gerente", StringComparison.OrdinalIgnoreCase))
        {
            effectiveArea = CurrentUserDivision;
        }

        var periodType = (periodo ?? scope ?? "mensual").Trim().ToLowerInvariant();
        DateTime periodStart;
        DateTime periodEnd;
        var now = DateTime.UtcNow;

        if (periodType.Contains("tri") || (valor != null && (valor.StartsWith("T", StringComparison.OrdinalIgnoreCase) || valor.Contains("Trimestre", StringComparison.OrdinalIgnoreCase))))
        {
            int quarter = 1;
            if (!string.IsNullOrWhiteSpace(valor))
            {
                if (valor.Contains("1") || valor.Contains("T1", StringComparison.OrdinalIgnoreCase)) quarter = 1;
                else if (valor.Contains("2") || valor.Contains("T2", StringComparison.OrdinalIgnoreCase)) quarter = 2;
                else if (valor.Contains("3") || valor.Contains("T3", StringComparison.OrdinalIgnoreCase)) quarter = 3;
                else if (valor.Contains("4") || valor.Contains("T4", StringComparison.OrdinalIgnoreCase)) quarter = 4;
            }
            else
            {
                quarter = (now.Month - 1) / 3 + 1;
            }

            var startMonth = (quarter - 1) * 3 + 1;
            periodStart = new DateTime(now.Year, startMonth, 1, 0, 0, 0, DateTimeKind.Utc);
            periodEnd = periodStart.AddMonths(3).AddTicks(-1);
        }
        else if (periodType.Contains("anu"))
        {
            periodStart = new DateTime(now.Year, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            periodEnd = new DateTime(now.Year, 12, 31, 23, 59, 59, 999, DateTimeKind.Utc);
        }
        else
        {
            int month = now.Month;
            if (!string.IsNullOrWhiteSpace(valor))
            {
                var v = valor.Trim().ToLowerInvariant();
                if (v.Contains("ene")) month = 1;
                else if (v.Contains("feb")) month = 2;
                else if (v.Contains("mar")) month = 3;
                else if (v.Contains("abr")) month = 4;
                else if (v.Contains("may")) month = 5;
                else if (v.Contains("jun")) month = 6;
                else if (v.Contains("jul")) month = 7;
                else if (v.Contains("ago")) month = 8;
                else if (v.Contains("sep")) month = 9;
                else if (v.Contains("oct")) month = 10;
                else if (v.Contains("nov")) month = 11;
                else if (v.Contains("dic")) month = 12;
                else if (int.TryParse(v, out var m) && m is >= 1 and <= 12) month = m;
            }

            periodStart = new DateTime(now.Year, month, 1, 0, 0, 0, DateTimeKind.Utc);
            periodEnd = periodStart.AddMonths(1).AddTicks(-1);
        }

        var allMetas = (await metaRepository.ObtenerAsync(periodStart, periodEnd, cancellationToken)) ?? [];
        var metas = allMetas
            .Where(x => string.IsNullOrWhiteSpace(scope) || string.Equals(x.PeriodoTipo, scope, StringComparison.OrdinalIgnoreCase))
            .ToList();

        var scopedOrders = (await GetScopedOrders(cancellationToken, effectiveArea))
            .Where(IsSaleOrder)
            .Where(x => x.FechaPedido >= periodStart && x.FechaPedido <= periodEnd)
            .ToList();

        var scopedUsers = (await GetScopedUsers(cancellationToken, effectiveArea)).ToList();
        if (!string.IsNullOrWhiteSpace(vendedor))
        {
            var q = vendedor.Trim();
            scopedUsers = scopedUsers.Where(u =>
                (u.CodVendedor != null && u.CodVendedor.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                (u.Nombre != null && u.Nombre.Contains(q, StringComparison.OrdinalIgnoreCase))
            ).ToList();
        }

        var usersBySeller = scopedUsers
            .Where(x => !string.IsNullOrWhiteSpace(x.CodVendedor))
            .ToDictionary(x => x.CodVendedor!, StringComparer.OrdinalIgnoreCase);

        var allPayments = (await cobroRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var appliedPayments = allPayments
            .Where(x => x.Status == PaymentStatus.Applied && x.CreatedAt >= periodStart && x.CreatedAt <= periodEnd)
            .ToList();

        List<object> data;
        if (metas.Count > 0)
        {
            data = metas.Select(meta =>
            {
                var sellerCodes = string.IsNullOrWhiteSpace(meta.VendedorCodigo)
                    ? usersBySeller.Where(x => string.IsNullOrWhiteSpace(meta.DivisionCodigo) || string.Equals(x.Value.Division, meta.DivisionCodigo, StringComparison.OrdinalIgnoreCase)).Select(x => x.Key).ToHashSet(StringComparer.OrdinalIgnoreCase)
                    : new HashSet<string>([meta.VendedorCodigo], StringComparer.OrdinalIgnoreCase);

                var isGeneral = string.IsNullOrWhiteSpace(meta.DivisionCodigo) && string.IsNullOrWhiteSpace(meta.VendedorCodigo);
                var divisionOrders = isGeneral
                    ? scopedOrders.ToList()
                    : scopedOrders.Where(x => sellerCodes.Contains(x.CodVendedor)).ToList();

                var sales = divisionOrders.Sum(x => x.TotalPedido);
                var customerCodes = divisionOrders.Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
                var collections = appliedPayments.Where(x => customerCodes.Contains(x.CodCliente)).Sum(x => x.Monto);
                var target = meta.Proyeccion;
                var code = meta.DivisionCodigo ?? meta.VendedorCodigo ?? "GENERAL";

                return (object)new
                {
                    id = meta.Id,
                    title = $"{code} ({meta.PeriodoTipo})",
                    code,
                    name = code,
                    projection = target,
                    sales,
                    pendingToSell = Math.Max(0, target - sales),
                    collections,
                    pendingToCollect = Math.Max(0, target - collections),
                    percentage = target == 0 ? 0 : Math.Round(sales / target * 100, 2),
                    current = sales,
                    target,
                    unit = "USD",
                    owner = meta.VendedorCodigo ?? $"División {code}",
                    status = target == 0 || sales < target * 0.7m ? "needs_attention" : "on_track"
                };
            }).ToList();
        }
        else
        {
            var divisionDefinitions = new (string Code, string Name, decimal Proj)[]
            {
                ("AGR", "Agrícola", 200000m),
                ("VET", "Veterinaria", 250000m),
                ("IND", "Industrial", 150000m),
                ("PRO", "Proyectos", 100000m),
                ("TAL", "Talleres", 80000m)
            };

            data = divisionDefinitions
                .Where(d => string.IsNullOrWhiteSpace(effectiveArea) || MatchAreaOrDivision(d.Name, effectiveArea) || MatchAreaOrDivision(d.Code, effectiveArea))
                .Select(d =>
                {
                    var divSellerCodes = usersBySeller
                        .Where(u => MatchAreaOrDivision(u.Value.Division, d.Code) || MatchAreaOrDivision(u.Value.Division, d.Name))
                        .Select(u => u.Key)
                        .ToHashSet(StringComparer.OrdinalIgnoreCase);

                    var divOrders = scopedOrders.Where(x => divSellerCodes.Contains(x.CodVendedor)).ToList();
                    var sales = divOrders.Sum(x => x.TotalPedido);
                    var customerCodes = divOrders.Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
                    var collections = appliedPayments.Where(x => customerCodes.Contains(x.CodCliente)).Sum(x => x.Monto);
                    var target = d.Proj;

                    return (object)new
                    {
                        id = $"div-{d.Code.ToLowerInvariant()}",
                        title = $"{d.Name} ({periodType})",
                        code = d.Code,
                        name = d.Name,
                        projection = target,
                        sales,
                        pendingToSell = Math.Max(0, target - sales),
                        collections,
                        pendingToCollect = Math.Max(0, target - collections),
                        percentage = target == 0 ? 0 : Math.Round(sales / target * 100, 2),
                        current = sales,
                        target,
                        unit = "USD",
                        owner = $"División {d.Name}",
                        status = target == 0 || sales < target * 0.7m ? "needs_attention" : "on_track"
                    };
                }).ToList();
        }

        return Ok(new { success = true, message = "Metas obtenidas.", data });
    }

    [Authorize(Roles = "Admin,Director,Gerente,Supervisor")]
    [HttpGet("approvals")]
    public async Task<IActionResult> Approvals(CancellationToken cancellationToken)
    {
        var orders = await GetScopedOrders(cancellationToken);
        var pendingOrders = orders.Where(x => x.Status == OrderStatus.PendingApproval || (x.Status != OrderStatus.Draft && string.Equals(x.Estatus, "Pendiente", StringComparison.OrdinalIgnoreCase))).ToList();
        
        var allInvoices = (await facturaRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var allCustomers = (await clienteRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var allUsers = (await usuarioRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        var data = new List<object>();
        foreach (var order in pendingOrders)
        {
            var customer = allCustomers.FirstOrDefault(x => string.Equals(x.CodCliente, order.CodCliente, StringComparison.OrdinalIgnoreCase));
            var seller = allUsers.FirstOrDefault(x => string.Equals(x.CodVendedor, order.CodVendedor, StringComparison.OrdinalIgnoreCase));
            var invoices = allInvoices.Where(x => string.Equals(x.CodCliente, order.CodCliente, StringComparison.OrdinalIgnoreCase)).ToList();
            var invoice = !string.IsNullOrWhiteSpace(order.NumFactura)
                ? invoices.FirstOrDefault(x => string.Equals(x.NumFactura, order.NumFactura, StringComparison.OrdinalIgnoreCase))
                : invoices.FirstOrDefault(x => x.OrderId == order.Id);
            var today = DateTime.UtcNow.Date;
            var overdue = invoices.Where(x => x.Saldo > 0 && x.FechaVencimiento.Date < today).ToList();
            var availableCredit = Math.Max(0, (customer?.MontoCredito ?? 0) - invoices.Sum(x => Math.Max(0, x.Saldo)));
            var totalDebt = invoices.Sum(x => Math.Max(0, x.Saldo));
            var amount = order.TotalPedido;
            data.Add(new
            {
                id = order.NumPedido,
                orderNumber = order.NumPedido,
                invoiceNumber = invoice?.NumFactura,
                customer = customer?.NomCliente ?? order.CodCliente,
                customerCode = order.CodCliente,
                customerDui = customer?.Dui,
                sellerName = seller?.Nombre ?? order.CodVendedor,
                sellerCode = order.CodVendedor,
                amount,
                reason = string.IsNullOrWhiteSpace(order.Observacion) ? "Pedido pendiente de aprobación" : order.Observacion,
                riskLevel = customer is null || customer.MontoCredito <= 0 ? "low" : amount > availableCredit ? "critical" : amount > availableCredit * 0.8m ? "high" : "medium",
                date = order.FechaPedido.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                deliveryDate = order.FechaEntrega?.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture) ?? string.Empty,
                deliveryAddress = order.DireccionEntrega ?? string.Empty,
                observations = order.Observacion,
                details = $"{order.Detalles?.Count ?? 0} línea(s) de pedido",
                type = "order_approval",
                status = "pending",
                financials = new
                {
                    creditLimit = customer?.MontoCredito ?? 0,
                    totalDebt,
                    availableCredit,
                    aging0to30 = overdue.Where(x => (today - x.FechaVencimiento.Date).Days <= 30).Sum(x => x.Saldo),
                    aging31to60 = overdue.Where(x => { var days = (today - x.FechaVencimiento.Date).Days; return days > 30 && days <= 60; }).Sum(x => x.Saldo),
                    aging61to90 = overdue.Where(x => { var days = (today - x.FechaVencimiento.Date).Days; return days > 60 && days <= 90; }).Sum(x => x.Saldo),
                    aging90Plus = overdue.Where(x => (today - x.FechaVencimiento.Date).Days > 90).Sum(x => x.Saldo),
                },
                items = (order.Detalles ?? []).Select(detail => (object)new
                {
                    id = detail.Id.ToString(),
                    productName = detail.NomProducto,
                    presentation = detail.Presentacion,
                    quantity = detail.Cantidad,
                    unitPrice = detail.PrecioUnitario,
                    totalPrice = detail.PrecioTotal
                }).ToList()
            });
        }

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

        var numFact = !string.IsNullOrWhiteSpace(pedido.NumFactura) ? pedido.NumFactura : pedido.NumPedido;
        var userName = User.Identity?.Name ?? CurrentUserDui ?? "Sistema";

        if (!IsPrivileged())
        {
            var scopedOrders = await GetScopedOrders(cancellationToken);
            if (!scopedOrders.Any(x => x.Id == pedido.Id))
                return Forbid();
        }

        try
        {
            var approval = await aprobacionRepository.ObtenerPorPedidoAsync(pedido.NumPedido, cancellationToken);
            if (approval is not null && approval.Estado is not ("pending" or "pendiente"))
                return Conflict(new { success = false, message = "La solicitud ya fue decidida." });

            await pedidoRepository.ActualizarEstadoAsync(pedido.NumPedido, status, null, cancellationToken);

            if (approval is not null) 
            {
                await aprobacionRepository.DecidirAsync(pedido.NumPedido, decision == "approve" ? "approved" : "rejected", CurrentUserId, request.Comment, cancellationToken);
            }
        }
        catch (Exception)
        {
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
                AfterData = System.Text.Json.JsonSerializer.Serialize(new
                {
                    status = decision,
                    comment = request.Comment,
                    numFact,
                    userName,
                    spInvoked = "[SAG].[InsertAutorizacion]"
                }),
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
                invoiceNumber = numFact,
                user = userName,
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
                foreach (var x in (await facturaRepository.ObtenerTodosAsync(cancellationToken) ?? []).Where(x => allowedCustomers is null || allowedCustomers.Contains(x.CodCliente))) csv.AppendLine($"{x.NumFactura},{x.CodCliente},{x.FechaEmision:yyyy-MM-dd},{x.TotalFactura.ToString(CultureInfo.InvariantCulture)},{x.Saldo.ToString(CultureInfo.InvariantCulture)},{x.Status}");
                break;
            case "payments":
                csv.AppendLine("factura,cliente,monto,metodo,estado,fecha");
                foreach (var x in (await cobroRepository.ObtenerTodosAsync(cancellationToken) ?? []).Where(x => allowedCustomers is null || allowedCustomers.Contains(x.CodCliente))) csv.AppendLine($"{x.NumFactura},{x.CodCliente},{x.Monto.ToString(CultureInfo.InvariantCulture)},{x.MetodoPago},{x.Status},{x.CreatedAt:yyyy-MM-dd}");
                break;
            default: return NotFound(new { success = false, message = "Reporte no encontrado." });
        }
        return File(Encoding.UTF8.GetBytes(csv.ToString()), "text/csv", $"SAGRISA_{id}.csv");
    }

    private static bool MatchAreaOrDivision(string? userDivision, string? requestedArea)
    {
        if (string.IsNullOrWhiteSpace(requestedArea) ||
            string.Equals(requestedArea, "all", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(requestedArea, "todas", StringComparison.OrdinalIgnoreCase))
            return true;

        if (string.IsNullOrWhiteSpace(userDivision))
            return false;

        var d = userDivision.Trim().ToLowerInvariant();
        var a = requestedArea.Trim().ToLowerInvariant();

        if (a is "a" or "agr" or "agricola" or "agrícola")
            return d.Contains("agri") || d == "a" || d == "agr";
        if (a is "v" or "vet" or "veterinaria")
            return d.Contains("vet") || d == "v" || d == "vet";
        if (a is "i" or "ind" or "industrial")
            return d.Contains("ind") || d == "i" || d == "ind";
        if (a is "t" or "tal" or "taller" or "talleres")
            return d.Contains("tal") || d == "t" || d == "tal";
        if (a is "p" or "pro" or "proyectos")
            return d.Contains("pro") || d == "p" || d == "pro";

        return d.Contains(a) || a.Contains(d);
    }

    private async Task<IReadOnlyCollection<Sagrisa.Domain.Entities.Pedido>> GetScopedOrders(CancellationToken cancellationToken, string? areaOverride = null)
    {
        var orders = (await pedidoRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        string? targetArea = areaOverride;
        if (string.IsNullOrWhiteSpace(targetArea) && string.Equals(CurrentUserRole, "Gerente", StringComparison.OrdinalIgnoreCase))
        {
            targetArea = CurrentUserDivision;
        }

        if (IsPrivileged())
        {
            if (!string.IsNullOrWhiteSpace(targetArea))
            {
                var users = (await usuarioRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
                var areaSellerCodes = users
                    .Where(u => MatchAreaOrDivision(u.Division, targetArea))
                    .Where(u => !string.IsNullOrWhiteSpace(u.CodVendedor))
                    .Select(u => u.CodVendedor!)
                    .ToHashSet(StringComparer.OrdinalIgnoreCase);

                return orders.Where(x => x.CodVendedor != null && areaSellerCodes.Contains(x.CodVendedor)).ToList();
            }
            return orders;
        }

        var sellers = await GetAllowedSellerCodes(cancellationToken);
        return orders.Where(x => x.CodVendedor is not null && sellers.Contains(x.CodVendedor)).ToList();
    }

    private async Task<IReadOnlyCollection<Sagrisa.Domain.Entities.Usuario>> GetScopedUsers(CancellationToken cancellationToken, string? areaOverride = null)
    {
        var users = (await usuarioRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        string? targetArea = areaOverride;
        if (string.IsNullOrWhiteSpace(targetArea) && string.Equals(CurrentUserRole, "Gerente", StringComparison.OrdinalIgnoreCase))
        {
            targetArea = CurrentUserDivision;
        }

        if (IsPrivileged())
        {
            if (!string.IsNullOrWhiteSpace(targetArea))
            {
                return users.Where(u => MatchAreaOrDivision(u.Division, targetArea)).ToList();
            }
            return users;
        }

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
        var customers = (await clienteRepository.ObtenerTodosAsync(cancellationToken)) ?? [];
        if (string.Equals(CurrentUserRole, "Vendedor", StringComparison.OrdinalIgnoreCase)) return customers.Where(x => x.Vendedor == CurrentUserCodVendedor).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var sellers = await GetAllowedSellerCodes(cancellationToken);
        return customers.Where(x => x.Vendedor is not null && sellers.Contains(x.Vendedor)).Select(x => x.CodCliente).ToHashSet(StringComparer.OrdinalIgnoreCase);
    }

    private bool IsPrivileged() => CurrentUserRole is "Admin" or "Director" or "Gerente";
}

public sealed class ApprovalDecisionRequest { public string? Decision { get; set; } public string? Comment { get; set; } }
