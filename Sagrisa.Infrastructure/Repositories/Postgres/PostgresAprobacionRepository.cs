using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresAprobacionRepository(SagrisaDbContext db) : IAprobacionRepository
{
    public async Task<IReadOnlyCollection<Aprobacion>> ObtenerPendientesAsync(CancellationToken cancellationToken = default)
        => await db.Aprobaciones.AsNoTracking()
            .Where(x => x.Estado == "pending" || x.Estado == "pendiente")
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync(cancellationToken);

    public Task<Aprobacion?> ObtenerPorPedidoAsync(string numPedido, CancellationToken cancellationToken = default)
        => db.Aprobaciones.FirstOrDefaultAsync(x => x.NumPedido == numPedido.Trim(), cancellationToken);

    public async Task<Aprobacion> CrearAsync(Aprobacion aprobacion, CancellationToken cancellationToken = default)
    {
        var existing = await db.Aprobaciones.FirstOrDefaultAsync(x => x.NumPedido == aprobacion.NumPedido, cancellationToken);
        if (existing is not null) return existing;
        db.Aprobaciones.Add(aprobacion);
        await db.SaveChangesAsync(cancellationToken);
        return aprobacion;
    }

    public async Task<bool> DecidirAsync(string numPedido, string estado, Guid? decididoPor, string? comentario, CancellationToken cancellationToken = default)
    {
        var item = await db.Aprobaciones.FirstOrDefaultAsync(x => x.NumPedido == numPedido.Trim() && (x.Estado == "pending" || x.Estado == "pendiente"), cancellationToken);
        if (item is null) return false;
        item.Estado = estado;
        item.DecididoPor = decididoPor;
        item.ComentarioDecision = comentario;
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }
}
