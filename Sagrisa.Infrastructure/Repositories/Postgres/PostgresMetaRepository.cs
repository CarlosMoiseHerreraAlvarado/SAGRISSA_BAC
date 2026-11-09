using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresMetaRepository(SagrisaDbContext db) : IMetaRepository
{
    public async Task<IReadOnlyCollection<MetaComercial>> ObtenerAsync(
        DateTime periodoInicio,
        DateTime periodoFin,
        CancellationToken cancellationToken = default)
        => await db.MetasComerciales.AsNoTracking()
            .Where(x => x.PeriodoInicio >= periodoInicio.Date && x.PeriodoFin <= periodoFin.Date)
            .OrderBy(x => x.DivisionCodigo)
            .ThenBy(x => x.VendedorCodigo)
            .ToListAsync(cancellationToken);
}
