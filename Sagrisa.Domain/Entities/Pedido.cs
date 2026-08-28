using Sagrisa.Domain.Enums;

namespace Sagrisa.Domain.Entities
{
    public class Pedido
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string CodVendedor { get; set; } = string.Empty;
        public string Tpago { get; set; } = "Contado";
        public DateTime FechaPedido { get; set; } = DateTime.UtcNow;
        public DateTime? FechaEntrega { get; set; }
        public int PlazoEntregaPedido { get; set; } = 1;
        public string Observacion { get; set; } = string.Empty;
        public decimal TotalPedido { get; set; }
        public string Pais { get; set; } = "SV";
        public int? IdDireccion { get; set; }
        public string? DireccionEntrega { get; set; }
        public decimal? Latitud { get; set; }
        public decimal? Longitud { get; set; }
        public bool IsSynced { get; set; } = true;
        public OrderStatus Status { get; set; } = OrderStatus.Draft;
        public string EstCorr { get; set; } = "A";
        public DateTime FechHoraInsert { get; set; } = DateTime.UtcNow;
        public string Origen { get; set; } = "PWA";
        public string IdBac { get; set; } = string.Empty;
        public string IdClieCaf { get; set; } = string.Empty;
        public string EstadoBac { get; set; } = string.Empty;
        public string OrderCaf { get; set; } = string.Empty;
        public string Estatus { get; set; } = "Activo";
        public string NumFactura { get; set; } = string.Empty;
        public string ErrCorreo { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        public List<PedidoDetalle> Detalles { get; set; } = [];
    }
}
