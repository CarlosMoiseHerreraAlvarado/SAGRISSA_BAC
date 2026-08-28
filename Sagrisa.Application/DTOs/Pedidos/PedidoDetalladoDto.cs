namespace Sagrisa.Application.DTOs.Pedidos
{
    public class PedidoDetalladoDto
    {
        public Guid Id { get; set; }
        public Guid? OrderId { get; set; }
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string CodProducto { get; set; } = string.Empty;
        public string NomProducto { get; set; } = string.Empty;
        public string Presentacion { get; set; } = "Unidad";
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PrecioTotal { get; set; }
        public string? CodVendedor { get; set; }
        public string Bodega { get; set; } = "B01";
        public string Origen { get; set; } = "PWA";
    }
}
