using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IPedidoRepository
    {
        Task<IReadOnlyCollection<Pedido>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Pedido>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codVendedor, string? codCliente, CancellationToken cancellationToken = default);
        Task<Pedido?> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken = default);
        Task<Pedido?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<Pedido> CrearAsync(Pedido pedido, CancellationToken cancellationToken = default);
        Task<bool> ActualizarEstadoAsync(string numero, string estatus, string? numFactura, CancellationToken cancellationToken = default);
    }
}
