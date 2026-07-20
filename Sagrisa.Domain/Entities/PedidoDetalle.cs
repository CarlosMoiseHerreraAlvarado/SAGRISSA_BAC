namespace Sagrisa.Domain.Entities
{
    // Representa una linea de detalle dentro de un pedido.
    // Cada linea es un producto con su cantidad, precio unitario y precio total.
    // El detalle siempre esta relacionado a un pedido mediante el campo NumPedido.
    public class PedidoDetalle
    {
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string CodProducto { get; set; } = string.Empty;
        public string NomProducto { get; set; } = string.Empty;
        public string Presentacion { get; set; } = string.Empty;
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PrecioTotal { get; set; }
        public string CodVendedor { get; set; } = string.Empty;
        public string Bodega { get; set; } = string.Empty;
        public string Origen { get; set; } = string.Empty;
    }
}
