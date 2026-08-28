namespace Sagrisa.Application.DTOs.Pedidos
{
    public class PedidoDetalladoResponseDto
    {
        public PedidoEncabezadoDto Encabezado { get; set; } = new();
        public List<PedidoDetalladoDto> Detalle { get; set; } = [];
    }
}
