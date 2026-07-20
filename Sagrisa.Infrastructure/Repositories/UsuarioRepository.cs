using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    // Repositorio mock de usuarios.
    // En lugar de conectarse a SQL Server, devuelve datos hardcodeados en memoria.
    // Cuando se tenga acceso a la base real, este archivo se reemplaza con consultas SQL/Dapper.
    public class UsuarioRepository : IUsuarioRepository
    {
        // Lista estatica que simula la tabla de usuarios en la base de datos.
        // Contiene 3 usuarios de ejemplo con diferentes roles y datos.
        private static readonly List<Usuario> _usuarios =
        [
            new Usuario
            {
                Pin = "77777",
                Nombre = "Marcos Antonio Gutierrez",
                Division = "Ventas",
                Pais = "El Salvador",
                CodVendedor = "GTCMARCOS",
                Cargo = "Vendedor",
                Email = "marcos@sagrisa.com",
                Cambiado = false,
                Dui = "00123456-7",
                DocPersonal = "DOC001",
                Token = "",
                FechaSesion = null,
                GerenciadoPor = "ADMIN01",
                SupervisadoPor = "SUP01",
                Rol = "Vendedor"
            },
            new Usuario
            {
                Pin = "12345",
                Nombre = "Juan Carlos Perez",
                Division = "Ventas",
                Pais = "El Salvador",
                CodVendedor = "GTJUAN",
                Cargo = "Vendedor Senior",
                Email = "juan@sagrisa.com",
                Cambiado = false,
                Dui = "00765432-1",
                DocPersonal = "DOC002",
                Token = "",
                FechaSesion = null,
                GerenciadoPor = "ADMIN01",
                SupervisadoPor = "SUP01",
                Rol = "Vendedor"
            },
            new Usuario
            {
                Pin = "99999",
                Nombre = "Maria Lopez",
                Division = "Administracion",
                Pais = "El Salvador",
                CodVendedor = "GTMARIA",
                Cargo = "Gerente",
                Email = "maria@sagrisa.com",
                Cambiado = false,
                Dui = "00987654-3",
                DocPersonal = "DOC003",
                Token = "",
                FechaSesion = null,
                GerenciadoPor = "",
                SupervisadoPor = "",
                Rol = "Admin"
            }
        ];

        // Devuelve todos los usuarios de la lista mock.
        public Task<IReadOnlyCollection<Usuario>> ObtenerTodosAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult<IReadOnlyCollection<Usuario>>(_usuarios);
        }

        // Busca un usuario por su codigo de vendedor.
        // Usa StringComparison.OrdinalIgnoreCase para que no importen las mayusculas/minusculas.
        public Task<Usuario?> ObtenerPorCodVendedorAsync(string codVendedor, CancellationToken cancellationToken)
        {
            var usuario = _usuarios.FirstOrDefault(u =>
                u.CodVendedor.Equals(codVendedor, StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(usuario);
        }
    }
}
