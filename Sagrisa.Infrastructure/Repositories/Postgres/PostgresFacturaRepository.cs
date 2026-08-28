using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresFacturaRepository(SagrisaDbContext db) : IFacturaRepository
{
    public async Task<IReadOnlyCollection<Factura>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        => await db.Facturas.AsNoTracking().OrderByDescending(x => x.FechaEmision).ToListAsync(cancellationToken);

    public async Task<PagedResult<Factura>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, CancellationToken cancellationToken = default)
    {
        var source = db.Facturas.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(codCliente))
            source = source.Where(x => x.CodCliente == codCliente.Trim());

        var total = await source.CountAsync(cancellationToken);
        var items = await source.OrderByDescending(x => x.FechaEmision)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<Factura>
        {
            Items = items,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = total
        };
    }

    public Task<Factura?> ObtenerPorNumeroAsync(string numFactura, CancellationToken cancellationToken = default)
        => db.Facturas.AsNoTracking().FirstOrDefaultAsync(x => x.NumFactura == numFactura.Trim(), cancellationToken);

    public Task<Factura?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        => db.Facturas.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    public async Task<bool> AplicarPagoAsync(Guid facturaId, decimal monto, CancellationToken cancellationToken = default)
    {
        await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
        var factura = await db.Facturas
            .FromSqlInterpolated($"select * from public.facturas where id = {facturaId} for update")
            .SingleOrDefaultAsync(cancellationToken);

        if (factura is null)
        {
            await transaction.RollbackAsync(cancellationToken);
            return false;
        }

        factura.Saldo = Math.Max(0, factura.Saldo - monto);
        factura.Status = factura.Saldo == 0 ? InvoiceStatus.Paid : InvoiceStatus.Partial;
        await db.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync(cancellationToken);
        return true;
    }
}
