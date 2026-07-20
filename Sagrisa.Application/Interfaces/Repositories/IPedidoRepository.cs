using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    // Interfaz que define como se accede a los datos de pedidos.
    // Por ahora solo permite lectura. La escritura (POST/PATCH) estara pendiente
    // hasta que se defina el mecanismo hacia Dynamics 365 (INT-004).
    public interface IPedidoRepository
    {
        // Devuelve todos los pedidos registrados (solo encabezado, sin detalle).
        Task<IReadOnlyCollection<Pedido>> ObtenerTodosAsync(CancellationToken cancellationToken);

        // Busca un pedido por su numero e incluye el detalle embebido.
        // Devuelve null si no lo encuentra.
        Task<Pedido?> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken);
    }
}
