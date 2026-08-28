using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    public class ClienteRepository : IClienteRepository
    {
        private static readonly List<Cliente> _clientes =
        [
            new Cliente
            {
                CodCliente = "C001",
                NomCliente = "Distribuidora La Paz S.A. de C.V.",
                Clase = "Mayorista",
                Vendedor = "GTCMARCOS",
                Ciudad = "San Salvador",
                Direccion = "Calle Principal #123, San Salvador",
                Telefono = "+503 2222-1111",
                TPago = "Credito",
                INACTIVE = 0,
                HOLD = 0,
                LPrecios = "LP01",
                MontoCredito = 5000.00m,
                TotalDeuda = 1200.00m,
                SaldoCredito = 3800.00m,
                Correo = "lapaz@correo.com"
            },
            new Cliente
            {
                CodCliente = "C002",
                NomCliente = "Supermercados El Ahorro",
                Clase = "Retail",
                Vendedor = "GTCMARCOS",
                Ciudad = "Santa Tecla",
                Direccion = "Av. San Martin #45, Santa Tecla",
                Telefono = "+503 2222-2222",
                TPago = "Contado",
                INACTIVE = 0,
                HOLD = 0,
                LPrecios = "LP02",
                MontoCredito = 10000.00m,
                TotalDeuda = 0m,
                SaldoCredito = 10000.00m,
                Correo = "ahorro@correo.com"
            },
            new Cliente
            {
                CodCliente = "C003",
                NomCliente = "Bodega San Miguel (INACTIVO)",
                Clase = "Minorista",
                Vendedor = "GTJUAN",
                Ciudad = "San Miguel",
                Direccion = "Carretera Panamericana Km 130",
                Telefono = "+503 2660-3333",
                TPago = "Credito",
                INACTIVE = 1,
                HOLD = 0,
                LPrecios = "LP01",
                MontoCredito = 2000.00m,
                TotalDeuda = 2000.00m,
                SaldoCredito = 0m,
                Correo = "bodegasm@correo.com"
            },
            new Cliente
            {
                CodCliente = "C004",
                NomCliente = "Comercial Los Pinos (BLOQUEADO)",
                Clase = "Mayorista",
                Vendedor = "GTCMARCOS",
                Ciudad = "Sonsonate",
                Direccion = "Barrio El Centro, Sonsonate",
                Telefono = "+503 2450-4444",
                TPago = "Credito",
                INACTIVE = 0,
                HOLD = 1,
                LPrecios = "LP03",
                MontoCredito = 3000.00m,
                TotalDeuda = 3500.00m,
                SaldoCredito = -500.00m,
                Correo = "lospinos@correo.com"
            },
            new Cliente
            {
                CodCliente = "C005",
                NomCliente = "Tienda Express",
                Clase = "Minorista",
                Vendedor = "GTJUAN",
                Ciudad = "Usulutan",
                Direccion = "Plaza Central Local 4",
                Telefono = "+503 2662-5555",
                TPago = "Contado",
                INACTIVE = 0,
                HOLD = 0,
                LPrecios = "LP02",
                MontoCredito = 1500.00m,
                TotalDeuda = 300.00m,
                SaldoCredito = 1200.00m,
                Correo = "expres@correo.com"
            },
            new Cliente
            {
                CodCliente = "C006",
                ProfileId = Guid.Parse("44444444-4444-4444-4444-444444444444"),
                NomCliente = "Cliente Demo SAGRISA",
                Dui = "00555555-5",
                Clase = "Retail",
                Vendedor = null,
                Ciudad = "San Salvador",
                Direccion = "Direccion demo",
                Telefono = "+503 7000-0000",
                TPago = "Contado",
                INACTIVE = 0,
                HOLD = 0,
                LPrecios = "LP01",
                MontoCredito = 2000.00m,
                TotalDeuda = 0.00m,
                SaldoCredito = 2000.00m,
                Correo = "cliente.demo@sagrisa.com"
            }
        ];

        public Task<IReadOnlyCollection<Cliente>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Cliente>>(_clientes);
        }

        public Task<PagedResult<Cliente>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? vendedor, string? query, CancellationToken cancellationToken = default)
        {
            var queryable = _clientes.AsQueryable();

            if (!string.IsNullOrWhiteSpace(vendedor))
            {
                queryable = queryable.Where(c => string.Equals(c.Vendedor, vendedor.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            if (!string.IsNullOrWhiteSpace(query))
            {
                var q = query.Trim();
                queryable = queryable.Where(c =>
                    (c.NomCliente != null && c.NomCliente.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (c.CodCliente != null && c.CodCliente.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (c.Ciudad != null && c.Ciudad.Contains(q, StringComparison.OrdinalIgnoreCase)));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Cliente>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Cliente?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo)) return Task.FromResult<Cliente?>(null);

            var cliente = _clientes.FirstOrDefault(c =>
                string.Equals(c.CodCliente, codigo.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(cliente);
        }

        public Task<IReadOnlyCollection<Cliente>> ObtenerPorVendedorAsync(string codVendedor, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codVendedor))
                return Task.FromResult<IReadOnlyCollection<Cliente>>(Array.Empty<Cliente>());

            var clientes = _clientes
                .Where(c => string.Equals(c.Vendedor, codVendedor.Trim(), StringComparison.OrdinalIgnoreCase))
                .ToList();

            return Task.FromResult<IReadOnlyCollection<Cliente>>(clientes);
        }

        public Task<bool> ActualizarDeudaAsync(string codCliente, decimal montoPagado, CancellationToken cancellationToken = default)
        {
            var cliente = _clientes.FirstOrDefault(c => string.Equals(c.CodCliente, codCliente, StringComparison.OrdinalIgnoreCase));
            if (cliente is null) return Task.FromResult(false);

            cliente.TotalDeuda = Math.Max(0, cliente.TotalDeuda - montoPagado);
            cliente.SaldoCredito = cliente.MontoCredito - cliente.TotalDeuda;

            return Task.FromResult(true);
        }
    }
}
