using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IAprobacionRepository
    {
        Task<IReadOnlyCollection<Aprobacion>> ObtenerPendientesAsync(CancellationToken cancellationToken = default);
        Task<Aprobacion?> ObtenerPorPedidoAsync(string numPedido, CancellationToken cancellationToken = default);
        Task<Aprobacion> CrearAsync(Aprobacion aprobacion, CancellationToken cancellationToken = default);
        Task<bool> DecidirAsync(string numPedido, string estado, Guid? decididoPor, string? comentario, CancellationToken cancellationToken = default);
    }
}
