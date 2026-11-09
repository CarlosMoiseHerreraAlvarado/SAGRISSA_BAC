using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories;

public sealed class EmptyMetaRepository : IMetaRepository
{
    public Task<IReadOnlyCollection<MetaComercial>> ObtenerAsync(DateTime periodoInicio, DateTime periodoFin, CancellationToken cancellationToken = default)
        => Task.FromResult<IReadOnlyCollection<MetaComercial>>([]);
}
