namespace Sagrisa.Application.DTOs.Pedidos
{
    // Objeto de transferencia que combina el encabezado de un pedido con su detalle.
    // Se usa para devolver un pedido completo cuando el frontend pide uno especifico.
    // Encabezado tiene la informacion general del pedido.
    // Detalle tiene la lista de productos que componen ese pedido.
    public class PedidoDetalladoResponseDto
    {
        public PedidoEncabezadoDto Encabezado { get; set; }
        public List<PedidoDetalladoDto> Detalle { get; set; }
    }
}
