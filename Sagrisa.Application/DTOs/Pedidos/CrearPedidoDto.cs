using System.ComponentModel.DataAnnotations;

namespace Sagrisa.Application.DTOs.Pedidos
{
    public class CrearPedidoDto
    {
        public Guid? Id { get; set; }

        [Required(ErrorMessage = "El código de cliente es obligatorio.")]
        public string CodCliente { get; set; } = string.Empty;

        public string? CodVendedor { get; set; }

        public string Tpago { get; set; } = "Contado";

        public DateTime? FechaEntrega { get; set; }

        public string? Observacion { get; set; }

        public string? DireccionEntrega { get; set; }

        public decimal? Latitud { get; set; }

        public decimal? Longitud { get; set; }

        [Required(ErrorMessage = "El pedido debe contener al menos un producto.")]
        [MinLength(1, ErrorMessage = "El pedido debe incluir al menos una línea de detalle.")]
        public List<CrearPedidoDetalleDto> Detalles { get; set; } = [];
    }

    public class CrearPedidoDetalleDto
    {
        public Guid? Id { get; set; }

        [Required(ErrorMessage = "El código del producto es obligatorio.")]
        public string CodProducto { get; set; } = string.Empty;

        [Range(1, 100000, ErrorMessage = "La cantidad debe ser mayor a cero.")]
        public decimal Cantidad { get; set; }

        public decimal? PrecioUnitario { get; set; }

        public string? Bodega { get; set; }
    }
}
