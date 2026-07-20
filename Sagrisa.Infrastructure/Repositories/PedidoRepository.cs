using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    // Repositorio mock de pedidos.
    // Contiene 3 pedidos de ejemplo con su detalle embebido.
    // Cada pedido tiene un不同的 estado, origen y cantidad de productos para probar distintos escenarios.
    // Los campos como IdBac, EstadoBac, orderCaf, idClieCaf se dejan vacios porque su uso esta pendiente.
    public class PedidoRepository : IPedidoRepository
    {
        private static readonly List<Pedido> _pedidos =
        [
            new Pedido
            {
                // Pedido 1 - Credito, origen APP, estado Activo, 2 productos
                NumPedido = "00012345",
                CodCliente = "C001",
                CodVendedor = "GTCMARCOS",
                Tpago = "Credito",
                FechaPedido = new DateTime(2026, 7, 15, 10, 30, 0),
                FechaEntrega = new DateTime(2026, 7, 20),
                PlazoEntregaPedido = 5,
                Observacion = "Pedido de prueba - entrega en bodega",
                TotalPedido = 262.50m,
                Pais = "SV",
                IdDireccion = 1,
                EstCorr = "A",
                FechHoraInsert = new DateTime(2026, 7, 15, 10, 30, 0),
                Origen = "APP",
                IdBac = "",
                IdClieCaf = "",
                EstadoBac = "",
                OrderCaf = "",
                Estatus = "Activo",
                NumFactura = "",
                ErrCorreo = "",
                Detalles =
                [
                    new PedidoDetalle
                    {
                        NumPedido = "00012345",
                        CodCliente = "C001",
                        CodProducto = "P001",
                        NomProducto = "Aceite Vegetal 1L",
                        Presentacion = "Unidad",
                        Cantidad = 15,
                        PrecioUnitario = 10.50m,
                        PrecioTotal = 157.50m,
                        CodVendedor = "GTCMARCOS",
                        Bodega = "B01",
                        Origen = "APP"
                    },
                    new PedidoDetalle
                    {
                        NumPedido = "00012345",
                        CodCliente = "C001",
                        CodProducto = "P002",
                        NomProducto = "Arroz Premium 5lb",
                        Presentacion = "Bolsa",
                        Cantidad = 10,
                        PrecioUnitario = 10.50m,
                        PrecioTotal = 105.00m,
                        CodVendedor = "GTCMARCOS",
                        Bodega = "B01",
                        Origen = "APP"
                    }
                ]
            },
            new Pedido
            {
                // Pedido 2 - Contado, origen LEGACY, estado Procesado, 3 productos, con factura
                NumPedido = "00012346",
                CodCliente = "C002",
                CodVendedor = "GTCMARCOS",
                Tpago = "Contado",
                FechaPedido = new DateTime(2026, 7, 16, 14, 0, 0),
                FechaEntrega = new DateTime(2026, 7, 18),
                PlazoEntregaPedido = 2,
                Observacion = "Entrega en tienda principal",
                TotalPedido = 787.50m,
                Pais = "SV",
                IdDireccion = 2,
                EstCorr = "E",
                FechHoraInsert = new DateTime(2026, 7, 16, 14, 0, 0),
                Origen = "LEGACY",
                IdBac = "",
                IdClieCaf = "",
                EstadoBac = "",
                OrderCaf = "",
                Estatus = "Procesado",
                NumFactura = "FAC-001",
                ErrCorreo = "",
                Detalles =
                [
                    new PedidoDetalle
                    {
                        NumPedido = "00012346",
                        CodCliente = "C002",
                        CodProducto = "P003",
                        NomProducto = "Cafe Molido 1lb",
                        Presentacion = "Paquete",
                        Cantidad = 50,
                        PrecioUnitario = 8.75m,
                        PrecioTotal = 437.50m,
                        CodVendedor = "GTCMARCOS",
                        Bodega = "B02",
                        Origen = "LEGACY"
                    },
                    new PedidoDetalle
                    {
                        NumPedido = "00012346",
                        CodCliente = "C002",
                        CodProducto = "P001",
                        NomProducto = "Aceite Vegetal 1L",
                        Presentacion = "Unidad",
                        Cantidad = 20,
                        PrecioUnitario = 10.50m,
                        PrecioTotal = 210.00m,
                        CodVendedor = "GTCMARCOS",
                        Bodega = "B02",
                        Origen = "LEGACY"
                    },
                    new PedidoDetalle
                    {
                        NumPedido = "00012346",
                        CodCliente = "C002",
                        CodProducto = "P004",
                        NomProducto = "Jabon en Barra",
                        Presentacion = "Unidad",
                        Cantidad = 25,
                        PrecioUnitario = 5.78m,
                        PrecioTotal = 144.50m,
                        CodVendedor = "GTCMARCOS",
                        Bodega = "B02",
                        Origen = "LEGACY"
                    }
                ]
            },
            new Pedido
            {
                // Pedido 3 - Contado, origen APP, estado Pendiente, 1 producto, sin direccion
                NumPedido = "00012347",
                CodCliente = "C005",
                CodVendedor = "GTJUAN",
                Tpago = "Contado",
                FechaPedido = new DateTime(2026, 7, 17, 9, 15, 0),
                FechaEntrega = new DateTime(2026, 7, 22),
                PlazoEntregaPedido = 5,
                Observacion = "",
                TotalPedido = 52.50m,
                Pais = "SV",
                IdDireccion = null,
                EstCorr = "P",
                FechHoraInsert = new DateTime(2026, 7, 17, 9, 15, 0),
                Origen = "APP",
                IdBac = "",
                IdClieCaf = "",
                EstadoBac = "",
                OrderCaf = "",
                Estatus = "Pendiente",
                NumFactura = "",
                ErrCorreo = "",
                Detalles =
                [
                    new PedidoDetalle
                    {
                        NumPedido = "00012347",
                        CodCliente = "C005",
                        CodProducto = "P002",
                        NomProducto = "Arroz Premium 5lb",
                        Presentacion = "Bolsa",
                        Cantidad = 5,
                        PrecioUnitario = 10.50m,
                        PrecioTotal = 52.50m,
                        CodVendedor = "GTJUAN",
                        Bodega = "B01",
                        Origen = "APP"
                    }
                ]
            }
        ];

        // Devuelve todos los pedidos de la lista mock.
        public Task<IReadOnlyCollection<Pedido>> ObtenerTodosAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult<IReadOnlyCollection<Pedido>>(_pedidos);
        }

        // Busca un pedido por su numero e incluye el detalle embebido.
        public Task<Pedido?> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken)
        {
            var pedido = _pedidos.FirstOrDefault(p =>
                p.NumPedido.Equals(numero, StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(pedido);
        }
    }
}
