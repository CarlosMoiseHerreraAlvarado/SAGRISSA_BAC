using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    // Interfaz que define como se accede a los datos de productos.
    // Util para el catalogo y tambien para futuras creaciones de pedidos
    // donde se necesite validar que un producto existe y esta activo.
    public interface IProductoRepository
    {
        // Devuelve todos los productos del catalogo (activos e inactivos).
        Task<IReadOnlyCollection<Producto>> ObtenerTodosAsync(CancellationToken cancellationToken);

        // Busca un producto por su codigo exacto.
        // Devuelve null si no lo encuentra.
        Task<Producto?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken);
    }
}
