using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private static readonly List<Usuario> _usuarios =
        [
            new Usuario
            {
                Id = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                Pin = "77777",
                PinHash = "$2a$11$w1h1BqC1717HkX0q5f5mquD5Lg27W6w7m21kF0w5f5mquD5Lg27W6", // Mock hash
                Nombre = "Marcos Antonio Gutierrez",
                Division = "Ventas",
                Pais = "El Salvador",
                CodVendedor = "GTCMARCOS",
                Cargo = "Vendedor",
                Email = "marcos@sagrisa.com",
                Cambiado = "N",
                Dui = "00123456-7",
                DocPersonal = "DOC001",
                Rol = "Vendedor",
                IsActive = true,
                IsOfflineCapable = true
            },
            new Usuario
            {
                Id = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                Pin = "12345",
                PinHash = null,
                Nombre = "Juan Carlos Perez",
                Division = "Ventas",
                Pais = "El Salvador",
                CodVendedor = "GTJUAN",
                Cargo = "Vendedor Senior",
                Email = "juan@sagrisa.com",
                Cambiado = "N",
                Dui = "00765432-1",
                DocPersonal = "DOC002",
                Rol = "Vendedor",
                IsActive = true,
                IsOfflineCapable = true
            },
            new Usuario
            {
                Id = Guid.Parse("33333333-3333-3333-3333-333333333333"),
                Pin = "99999",
                PinHash = null,
                Nombre = "Maria Lopez",
                Division = "Administracion",
                Pais = "El Salvador",
                CodVendedor = "GTMARIA",
                Cargo = "Gerente",
                Email = "maria@sagrisa.com",
                Cambiado = "N",
                Dui = "00987654-3",
                DocPersonal = "DOC003",
                Rol = "Admin",
                IsActive = true,
                IsOfflineCapable = false
            },
            new Usuario
            {
                Id = Guid.Parse("44444444-4444-4444-4444-444444444444"),
                Pin = "55555",
                PinHash = null,
                Nombre = "Cliente Demo SAGRISA",
                Division = "Clientes",
                Pais = "El Salvador",
                CodVendedor = null,
                Cargo = "Cliente",
                Email = "cliente.demo@sagrisa.com",
                Cambiado = "N",
                Dui = "00555555-5",
                DocPersonal = "DOC004",
                Rol = "Cliente",
                IsActive = true,
                IsOfflineCapable = false
            }
        ];

        public Task<IReadOnlyCollection<Usuario>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Usuario>>(_usuarios);
        }

        public Task<PagedResult<Usuario>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? query, CancellationToken cancellationToken = default)
        {
            var queryable = _usuarios.AsQueryable();

            if (!string.IsNullOrWhiteSpace(query))
            {
                var q = query.Trim();
                queryable = queryable.Where(u =>
                    (u.Nombre != null && u.Nombre.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (u.Dui != null && u.Dui.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (u.CodVendedor != null && u.CodVendedor.Contains(q, StringComparison.OrdinalIgnoreCase)));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Usuario>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Usuario?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var usuario = _usuarios.FirstOrDefault(u => u.Id == id);
            return Task.FromResult(usuario);
        }

        public Task<Usuario?> ObtenerPorCodVendedorAsync(string codVendedor, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codVendedor)) return Task.FromResult<Usuario?>(null);

            var usuario = _usuarios.FirstOrDefault(u =>
                string.Equals(u.CodVendedor, codVendedor.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(usuario);
        }

        public Task<Usuario?> ObtenerPorDuiAsync(string dui, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(dui)) return Task.FromResult<Usuario?>(null);

            var usuario = _usuarios.FirstOrDefault(u =>
                string.Equals(u.Dui, dui.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(usuario);
        }

        public Task<bool> ActualizarPinAsync(Guid id, string pinHash, CancellationToken cancellationToken = default)
        {
            var usuario = _usuarios.FirstOrDefault(u => u.Id == id);
            if (usuario is null) return Task.FromResult(false);

            usuario.PinHash = pinHash;
            usuario.Pin = null; // Borrar version en texto plano al migrar
            usuario.UpdatedAt = DateTime.UtcNow;

            return Task.FromResult(true);
        }

        public Task<Usuario> CrearAsync(Usuario usuario, CancellationToken cancellationToken = default)
        {
            _usuarios.Add(usuario);
            return Task.FromResult(usuario);
        }
    }
}
