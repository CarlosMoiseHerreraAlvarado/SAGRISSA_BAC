using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface ICobroRepository
    {
        Task<IReadOnlyCollection<Cobro>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Cobro>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, string? codVendedor, CancellationToken cancellationToken = default);
        Task<Cobro?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<Cobro> CrearAsync(Cobro cobro, CancellationToken cancellationToken = default);
        Task<bool> ActualizarEstadoAsync(Guid id, Sagrisa.Domain.Enums.PaymentStatus status, CancellationToken cancellationToken = default);
    }
}
