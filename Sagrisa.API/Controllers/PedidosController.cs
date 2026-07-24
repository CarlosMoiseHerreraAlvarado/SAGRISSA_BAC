using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    // Controlador que maneja las peticiones relacionadas con pedidos.
    // Ruta base: /api/pedidos
    // Permite listar todos los pedidos o buscar uno especifico con su detalle completo.
    [Route("api/pedidos")]
    [Route("pedidos")]
    public class PedidosController : SagrisaBaseController
    {
        private readonly IPedidoRepository _pedidoRepository;

        public PedidosController(IPedidoRepository pedidoRepository)
        {
            _pedidoRepository = pedidoRepository;
        }

        // GET /api/pedidos
        // Devuelve el encabezado de todos los pedidos sin el detalle.
        // Cada pedido muestra informacion general como cliente, vendedor, total, estado, etc.
        [HttpGet]
        public async Task<IActionResult> ObtenerTodos(CancellationToken cancellationToken)
        {
            var pedidos = await _pedidoRepository.ObtenerTodosAsync(cancellationToken);

            var resultado = pedidos.Select(p => new PedidoEncabezadoDto
            {
                NumPedido = p.NumPedido,
                CodCliente = p.CodCliente,
                CodVendedor = p.CodVendedor,
                Tpago = p.Tpago,
                FechaPedido = p.FechaPedido.ToString("yyyy-MM-dd HH:mm:ss"),
                FechaEntrega = p.FechaEntrega?.ToString("yyyy-MM-dd"),
                PlazoEntregaPedido = p.PlazoEntregaPedido,
                Observacion = p.Observacion,
                TotalPedido = p.TotalPedido,
                Pais = p.Pais,
                IdDireccion = p.IdDireccion ?? 0,
                EstCorr = p.EstCorr,
                FechHoraInsert = p.FechHoraInsert,
                Origen = p.Origen,
                idBac = p.IdBac,
                idClieCaf = p.IdClieCaf,
                EstadoBac = p.EstadoBac,
                orderCaf = p.OrderCaf,
                estatus = p.Estatus,
                NumFactura = p.NumFactura,
                ErrCorreo = p.ErrCorreo
            }).ToList();

            return Ok(resultado);
        }

        // GET /api/pedidos/00012345
        // Devuelve un pedido especifico con todo su detalle (encabezado + lineas de producto).
        // El detalle viene embebido dentro de la respuesta, no es un endpoint aparte.
        [HttpGet("{numero}")]
        public async Task<IActionResult> ObtenerPorNumero(string numero, CancellationToken cancellationToken)
        {
            var pedido = await _pedidoRepository.ObtenerPorNumeroAsync(numero, cancellationToken);

            if (pedido is null)
                return NotFound(new { Success = false, Message = $"Pedido '{numero}' no encontrado." });

            // Se construye el encabezado del pedido.
            var encabezado = new PedidoEncabezadoDto
            {
                NumPedido = pedido.NumPedido,
                CodCliente = pedido.CodCliente,
                CodVendedor = pedido.CodVendedor,
                Tpago = pedido.Tpago,
                FechaPedido = pedido.FechaPedido.ToString("yyyy-MM-dd HH:mm:ss"),
                FechaEntrega = pedido.FechaEntrega?.ToString("yyyy-MM-dd"),
                PlazoEntregaPedido = pedido.PlazoEntregaPedido,
                Observacion = pedido.Observacion,
                TotalPedido = pedido.TotalPedido,
                Pais = pedido.Pais,
                IdDireccion = pedido.IdDireccion ?? 0,
                EstCorr = pedido.EstCorr,
                FechHoraInsert = pedido.FechHoraInsert,
                Origen = pedido.Origen,
                idBac = pedido.IdBac,
                idClieCaf = pedido.IdClieCaf,
                EstadoBac = pedido.EstadoBac,
                orderCaf = pedido.OrderCaf,
                estatus = pedido.Estatus,
                NumFactura = pedido.NumFactura,
                ErrCorreo = pedido.ErrCorreo
            };

            // Se construye la lista de productos que componen el pedido.
            var detalle = pedido.Detalles.Select(d => new PedidoDetalladoDto
            {
                NumPedido = d.NumPedido,
                CodCliente = d.CodCliente,
                CodProducto = d.CodProducto,
                NomProducto = d.NomProducto,
                Presentacion = d.Presentacion,
                Cantidad = d.Cantidad,
                PrecioUnitario = d.PrecioUnitario,
                PrecioTotal = d.PrecioTotal,
                CodVendedor = d.CodVendedor,
                Bodega = d.Bodega,
                Origen = d.Origen
            }).ToList();

            // Se arma la respuesta completa: encabezado mas sus lineas de detalle.
            var respuesta = new PedidoDetalladoResponseDto
            {
                Encabezado = encabezado,
                Detalle = detalle
            };

            return Ok(respuesta);
        }
    }
}
