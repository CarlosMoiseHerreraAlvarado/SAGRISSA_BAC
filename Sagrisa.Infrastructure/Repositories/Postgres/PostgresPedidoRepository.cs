using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresPedidoRepository(SagrisaDbContext db) : IPedidoRepository
{
    public async Task<IReadOnlyCollection<Pedido>> ObtenerTodosAsync(CancellationToken cancellationToken = default) => await db.Pedidos.AsNoTracking().Include(x => x.Detalles).OrderByDescending(x => x.FechaPedido).ToListAsync(cancellationToken);

    public async Task<PagedResult<Pedido>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codVendedor, string? codCliente, CancellationToken cancellationToken = default)
    {
        var source = db.Pedidos.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(codVendedor)) source = source.Where(x => x.CodVendedor == codVendedor.Trim());
        if (!string.IsNullOrWhiteSpace(codCliente)) source = source.Where(x => x.CodCliente == codCliente.Trim());
        var total = await source.CountAsync(cancellationToken);
        var items = await source.Include(x => x.Detalles).OrderByDescending(x => x.FechaPedido).Skip((pageNumber - 1) * pageSize).Take(pageSize).ToListAsync(cancellationToken);
        return new PagedResult<Pedido> { Items = items, PageNumber = pageNumber, PageSize = pageSize, TotalCount = total };
    }

    public Task<Pedido?> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken = default) => db.Pedidos.AsNoTracking().Include(x => x.Detalles).FirstOrDefaultAsync(x => x.NumPedido == numero.Trim(), cancellationToken);
    public Task<Pedido?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default) => db.Pedidos.AsNoTracking().Include(x => x.Detalles).FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    public async Task<Pedido> CrearAsync(Pedido pedido, CancellationToken cancellationToken = default)
    {
        if (pedido.Id == Guid.Empty) pedido.Id = Guid.NewGuid();
        foreach (var detalle in pedido.Detalles) detalle.OrderId = pedido.Id;
        // SaveChangesAsync ya usa una transacción atómica para este único agregado.
        db.Pedidos.Add(pedido);
        await db.SaveChangesAsync(cancellationToken);
        return pedido;
    }

    public async Task<bool> ActualizarEstadoAsync(string numero, string estatus, string? numFactura, CancellationToken cancellationToken = default)
    {
        var pedido = await db.Pedidos.FirstOrDefaultAsync(x => x.NumPedido == numero.Trim(), cancellationToken);
        if (pedido is null) return false;
        pedido.Estatus = estatus;
        pedido.Status = estatus.Trim().ToLowerInvariant() switch
        {
            "aprobado" or "approved" => OrderStatus.Approved,
            "rechazado" or "rejected" or "anulado" => OrderStatus.Rejected,
            "procesado" or "procesado_erp" or "facturado" => OrderStatus.Fulfilled,
            "pendiente" or "pending" => OrderStatus.PendingApproval,
            _ => pedido.Status
        };
        if (!string.IsNullOrWhiteSpace(numFactura)) pedido.NumFactura = numFactura;
        pedido.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }
}
