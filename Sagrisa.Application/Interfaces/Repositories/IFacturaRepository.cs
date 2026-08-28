using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IFacturaRepository
    {
        Task<IReadOnlyCollection<Factura>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Factura>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, CancellationToken cancellationToken = default);
        Task<Factura?> ObtenerPorNumeroAsync(string numFactura, CancellationToken cancellationToken = default);
        Task<Factura?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<bool> AplicarPagoAsync(Guid facturaId, decimal monto, CancellationToken cancellationToken = default);
    }
}
