using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IProductoRepository
    {
        Task<IReadOnlyCollection<Producto>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Producto>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? familia, bool? soloActivos, string? query, CancellationToken cancellationToken = default);
        Task<Producto?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default);
        Task<Producto?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<Producto> CrearAsync(Producto producto, CancellationToken cancellationToken = default);
        Task<Producto?> ActualizarAsync(string codigo, Producto producto, CancellationToken cancellationToken = default);
    }
}
