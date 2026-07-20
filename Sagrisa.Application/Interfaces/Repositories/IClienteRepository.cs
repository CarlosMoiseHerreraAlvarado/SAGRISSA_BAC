using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    // Interfaz que define como se accede a los datos de clientes.
    // Permite buscar todos, por codigo especifico, o filtrar por vendedor.
    public interface IClienteRepository
    {
        // Devuelve todos los clientes registrados.
        Task<IReadOnlyCollection<Cliente>> ObtenerTodosAsync(CancellationToken cancellationToken);

        // Busca un cliente por su codigo exacto.
        // Devuelve null si no lo encuentra.
        Task<Cliente?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken);

        // Devuelve solo los clientes asignados a un vendedor especifico.
        Task<IReadOnlyCollection<Cliente>> ObtenerPorVendedorAsync(string codVendedor, CancellationToken cancellationToken);
    }
}
