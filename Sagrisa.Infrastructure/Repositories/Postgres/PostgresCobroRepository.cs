using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresCobroRepository(SagrisaDbContext db) : ICobroRepository
{
    public async Task<IReadOnlyCollection<Cobro>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        => await db.Cobros.AsNoTracking().OrderByDescending(x => x.CreatedAt).ToListAsync(cancellationToken);

    public async Task<PagedResult<Cobro>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, string? codVendedor, CancellationToken cancellationToken = default)
    {
        var source = db.Cobros.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(codCliente))
            source = source.Where(x => x.CodCliente == codCliente.Trim());
        if (!string.IsNullOrWhiteSpace(codVendedor))
            source = source.Where(x => x.CodVendedor == codVendedor.Trim());

        var total = await source.CountAsync(cancellationToken);
        var items = await source.OrderByDescending(x => x.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<Cobro>
        {
            Items = items,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = total
        };
    }

    public Task<Cobro?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        => db.Cobros.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    public async Task<Cobro> CrearAsync(Cobro cobro, CancellationToken cancellationToken = default)
    {
        if (cobro.Id == Guid.Empty) cobro.Id = Guid.NewGuid();
        db.Cobros.Add(cobro);
        try
        {
            await db.SaveChangesAsync(cancellationToken);
            return cobro;
        }
        catch (DbUpdateException)
        {
            db.Entry(cobro).State = EntityState.Detached;
            var existing = await db.Cobros.AsNoTracking().FirstOrDefaultAsync(x =>
                x.Id == cobro.Id || (cobro.Referencia != null && x.FacturaId == cobro.FacturaId && x.Referencia == cobro.Referencia), cancellationToken);
            if (existing is not null) return existing;
            throw;
        }
    }

    public async Task<Cobro?> AplicarAsync(Guid id, CancellationToken cancellationToken = default)
    {
        await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
        var cobro = await db.Cobros
            .FromSqlInterpolated($"select * from sagrisa.cobros where id = {id} for update")
            .SingleOrDefaultAsync(cancellationToken);
        if (cobro is null) return null;
        if (cobro.Status == PaymentStatus.Applied)
        {
            await transaction.CommitAsync(cancellationToken);
            return cobro;
        }

        var factura = await db.Facturas
            .FromSqlInterpolated($"select * from sagrisa.facturas where id = {cobro.FacturaId} for update")
            .SingleOrDefaultAsync(cancellationToken);
        if (factura is null || cobro.Monto <= 0 || cobro.Monto > factura.Saldo) return null;

        factura.Saldo -= cobro.Monto;
        factura.Status = factura.Saldo == 0 ? InvoiceStatus.Paid : InvoiceStatus.Partial;
        var cliente = await db.Clientes.FirstOrDefaultAsync(x => x.CodCliente == cobro.CodCliente, cancellationToken);
        if (cliente is not null)
        {
            cliente.TotalDeuda = Math.Max(0, cliente.TotalDeuda - cobro.Monto);
            cliente.SaldoCredito = cliente.MontoCredito - cliente.TotalDeuda;
        }
        cobro.Status = PaymentStatus.Applied;
        await db.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync(cancellationToken);
        return cobro;
    }

    public async Task<bool> ActualizarEstadoAsync(Guid id, PaymentStatus status, CancellationToken cancellationToken = default)
    {
        var cobro = await db.Cobros.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        if (cobro is null) return false;

        cobro.Status = status;
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }
}
