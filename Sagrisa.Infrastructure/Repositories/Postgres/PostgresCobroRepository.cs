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
        await db.SaveChangesAsync(cancellationToken);
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
