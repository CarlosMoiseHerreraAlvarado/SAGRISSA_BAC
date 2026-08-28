using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IUsuarioRepository
    {
        Task<IReadOnlyCollection<Usuario>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<PagedResult<Usuario>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? query, CancellationToken cancellationToken = default);
        Task<Usuario?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default);
        Task<Usuario?> ObtenerPorCodVendedorAsync(string codVendedor, CancellationToken cancellationToken = default);
        Task<Usuario?> ObtenerPorDuiAsync(string dui, CancellationToken cancellationToken = default);
        Task<bool> ActualizarPinAsync(Guid id, string pinHash, CancellationToken cancellationToken = default);
        Task<Usuario> CrearAsync(Usuario usuario, CancellationToken cancellationToken = default);
    }
}
