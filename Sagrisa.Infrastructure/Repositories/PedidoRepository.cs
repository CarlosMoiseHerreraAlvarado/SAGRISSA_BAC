using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Infrastructure.Repositories
{
    public class PedidoRepository : IPedidoRepository
    {
        private static readonly List<Pedido> _pedidos =
        [
            new Pedido
            {
                Id = Guid.Parse("11111111-aaaa-aaaa-aaaa-111111111111"),
                NumPedido = "00012345",
                CodCliente = "C001",
                CodVendedor = "GTCMARCOS",
                Tpago = "Credito",
                FechaPedido = new DateTime(2026, 7, 15, 10, 30, 0, DateTimeKind.Utc),
                FechaEntrega = new DateTime(2026, 7, 20, 0, 0, 0, DateTimeKind.Utc),
                PlazoEntregaPedido = 5,
                Observacion = "Pedido de prueba - entrega en bodega",
                TotalPedido = 262.50m,
                Pais = "SV",
                IdDireccion = 1,
                DireccionEntrega = "Calle Principal #123, San Salvador",
                Status = OrderStatus.Approved,
                EstCorr = "A",
                FechHoraInsert = new DateTime(2026, 7, 15, 10, 30, 0, DateTimeKind.Utc),
                Origen = "PWA",
                Estatus = "Activo",
                Detalles =
                [
                    new PedidoDetalle
                    {
                        Id = Guid.NewGuid(),
                        OrderId = Guid.Parse("11111111-aaaa-aaaa-aaaa-111111111111"),
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
                        Origen = "PWA"
                    },
                    new PedidoDetalle
                    {
                        Id = Guid.NewGuid(),
                        OrderId = Guid.Parse("11111111-aaaa-aaaa-aaaa-111111111111"),
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
                        Origen = "PWA"
                    }
                ]
            },
            new Pedido
            {
                Id = Guid.Parse("22222222-bbbb-bbbb-bbbb-222222222222"),
                NumPedido = "00012346",
                CodCliente = "C002",
                CodVendedor = "GTCMARCOS",
                Tpago = "Contado",
                FechaPedido = new DateTime(2026, 7, 16, 14, 0, 0, DateTimeKind.Utc),
                FechaEntrega = new DateTime(2026, 7, 18, 0, 0, 0, DateTimeKind.Utc),
                PlazoEntregaPedido = 2,
                Observacion = "Entrega en tienda principal",
                TotalPedido = 787.50m,
                Pais = "SV",
                IdDireccion = 2,
                DireccionEntrega = "Av. San Martin #45, Santa Tecla",
                Status = OrderStatus.Fulfilled,
                EstCorr = "E",
                FechHoraInsert = new DateTime(2026, 7, 16, 14, 0, 0, DateTimeKind.Utc),
                Origen = "PWA",
                Estatus = "Procesado",
                NumFactura = "FAC-001",
                Detalles =
                [
                    new PedidoDetalle
                    {
                        Id = Guid.NewGuid(),
                        OrderId = Guid.Parse("22222222-bbbb-bbbb-bbbb-222222222222"),
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
                        Origen = "PWA"
                    },
                    new PedidoDetalle
                    {
                        Id = Guid.NewGuid(),
                        OrderId = Guid.Parse("22222222-bbbb-bbbb-bbbb-222222222222"),
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
                        Origen = "PWA"
                    }
                ]
            }
        ];

        public Task<IReadOnlyCollection<Pedido>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Pedido>>(_pedidos);
        }

        public Task<PagedResult<Pedido>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codVendedor, string? codCliente, CancellationToken cancellationToken = default)
        {
            var queryable = _pedidos.AsQueryable();

            if (!string.IsNullOrWhiteSpace(codVendedor))
            {
                queryable = queryable.Where(p => string.Equals(p.CodVendedor, codVendedor.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            if (!string.IsNullOrWhiteSpace(codCliente))
            {
                queryable = queryable.Where(p => string.Equals(p.CodCliente, codCliente.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .OrderByDescending(p => p.FechaPedido)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Pedido>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Pedido?> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(numero)) return Task.FromResult<Pedido?>(null);

            var pedido = _pedidos.FirstOrDefault(p =>
                string.Equals(p.NumPedido, numero.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(pedido);
        }

        public Task<Pedido?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var pedido = _pedidos.FirstOrDefault(p => p.Id == id);
            return Task.FromResult(pedido);
        }

        public Task<Pedido> CrearAsync(Pedido pedido, CancellationToken cancellationToken = default)
        {
            _pedidos.Insert(0, pedido);
            return Task.FromResult(pedido);
        }

        public Task<bool> ActualizarEstadoAsync(string numero, string estatus, string? numFactura, CancellationToken cancellationToken = default)
        {
            var pedido = _pedidos.FirstOrDefault(p => string.Equals(p.NumPedido, numero.Trim(), StringComparison.OrdinalIgnoreCase));
            if (pedido is null) return Task.FromResult(false);

            pedido.Estatus = estatus;
            pedido.Status = estatus.Trim().ToLowerInvariant() switch
            {
                "aprobado" or "approved" => OrderStatus.Approved,
                "rechazado" or "rejected" or "anulado" => OrderStatus.Rejected,
                "procesado" or "procesado_erp" or "facturado" => OrderStatus.Fulfilled,
                "pendiente" or "pending" => OrderStatus.PendingApproval,
                _ => pedido.Status
            };
            if (!string.IsNullOrEmpty(numFactura))
            {
                pedido.NumFactura = numFactura;
            }
            pedido.UpdatedAt = DateTime.UtcNow;

            return Task.FromResult(true);
        }
    }
}
