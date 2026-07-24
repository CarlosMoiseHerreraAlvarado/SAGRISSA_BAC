using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    // Interfaz que define como se accede a los datos de usuarios.
    // Esta interfaz vive en Application, pero la implementacion real esta en Infrastructure.
    // Esto permite cambiar de mock a SQL Server sin modificar el resto del codigo.
    public interface IUsuarioRepository
    {
        // Devuelve todos los usuarios registrados en el sistema.
        Task<IReadOnlyCollection<Usuario>> ObtenerTodosAsync(CancellationToken cancellationToken);

        // Busca un usuario por su codigo de vendedor.
        // Devuelve null si no lo encuentra.
        Task<Usuario?> ObtenerPorCodVendedorAsync(string codVendedor, CancellationToken cancellationToken);

        // Busca un usuario por su DUI.
        // Se usa en el login: el frontend envia DUI + PIN.
        Task<Usuario?> ObtenerPorDuiAsync(string dui, CancellationToken cancellationToken);
    }
}
