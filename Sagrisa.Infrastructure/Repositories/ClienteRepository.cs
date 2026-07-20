using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    // Repositorio mock de clientes.
    // Contiene 5 clientes de ejemplo que cubren diferentes escenarios:
    // clientes activos, inactivos y bloqueados, para poder probar todos los casos.
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
                TPago = "Credito",
                INACTIVE = false,
                HOLD = false,
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
                TPago = "Contado",
                INACTIVE = false,
                HOLD = false,
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
                TPago = "Credito",
                INACTIVE = true,
                HOLD = false,
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
                TPago = "Credito",
                INACTIVE = false,
                HOLD = true,
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
                TPago = "Contado",
                INACTIVE = false,
                HOLD = false,
                LPrecios = "LP02",
                MontoCredito = 1500.00m,
                TotalDeuda = 300.00m,
                SaldoCredito = 1200.00m,
                Correo = "expres@correo.com"
            }
        ];

        // Devuelve todos los clientes de la lista mock.
        public Task<IReadOnlyCollection<Cliente>> ObtenerTodosAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult<IReadOnlyCollection<Cliente>>(_clientes);
        }

        // Busca un cliente por su codigo exacto.
        public Task<Cliente?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken)
        {
            var cliente = _clientes.FirstOrDefault(c =>
                c.CodCliente.Equals(codigo, StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(cliente);
        }

        // Filtra y devuelve solo los clientes asignados a un vendedor especifico.
        public Task<IReadOnlyCollection<Cliente>> ObtenerPorVendedorAsync(string codVendedor, CancellationToken cancellationToken)
        {
            var clientes = _clientes
                .Where(c => c.Vendedor.Equals(codVendedor, StringComparison.OrdinalIgnoreCase))
                .ToList();

            return Task.FromResult<IReadOnlyCollection<Cliente>>(clientes);
        }
    }
}
