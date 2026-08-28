namespace Sagrisa.Domain.Entities
{
    public class PedidoDetalle
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? OrderId { get; set; }
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string CodProducto { get; set; } = string.Empty;
        public string NomProducto { get; set; } = string.Empty;
        public string Presentacion { get; set; } = "Unidad";
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PrecioTotal { get; set; }
        public string CodVendedor { get; set; } = string.Empty;
        public string Bodega { get; set; } = "B01";
        public string Origen { get; set; } = "PWA";
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
