using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IClienteRepository
    {
        Task<IReadOnlyCollection<Cliente>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Cliente>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? vendedor, string? query, CancellationToken cancellationToken = default);
        Task<Cliente?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default);
        Task<IReadOnlyCollection<Cliente>> ObtenerPorVendedorAsync(string codVendedor, CancellationToken cancellationToken = default);
        Task<bool> ActualizarDeudaAsync(string codCliente, decimal montoPagado, CancellationToken cancellationToken = default);
    }
}
