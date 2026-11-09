using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories;

public interface IMetaRepository
{
    Task<IReadOnlyCollection<MetaComercial>> ObtenerAsync(DateTime periodoInicio, DateTime periodoFin, CancellationToken cancellationToken = default);
}
