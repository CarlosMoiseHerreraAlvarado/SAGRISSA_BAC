using Sagrisa.Domain.Enums;

namespace Sagrisa.Application.DTOs.Pedidos
{
    public class PedidoEncabezadoDto
    {
        public Guid Id { get; set; }
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string? CodVendedor { get; set; }
        public string Tpago { get; set; } = "Contado";
        public string FechaPedido { get; set; } = string.Empty;
        public string? FechaEntrega { get; set; }
        public int PlazoEntregaPedido { get; set; }
        public string? Observacion { get; set; }
        public decimal TotalPedido { get; set; }
        public string Pais { get; set; } = "SV";
        public int? IdDireccion { get; set; }
        public string? DireccionEntrega { get; set; }
        public decimal? Latitud { get; set; }
        public decimal? Longitud { get; set; }
        public OrderStatus Status { get; set; } = OrderStatus.Draft;
        public bool IsSynced { get; set; } = true;
        public string EstCorr { get; set; } = string.Empty;
        public DateTime FechHoraInsert { get; set; }
        public string Origen { get; set; } = "PWA";
        public string IdBac { get; set; } = string.Empty;
        public string IdClieCaf { get; set; } = string.Empty;
        public string EstadoBac { get; set; } = string.Empty;
        public string OrderCaf { get; set; } = string.Empty;
        public string Estatus { get; set; } = string.Empty;
        public string NumFactura { get; set; } = string.Empty;
        public string ErrCorreo { get; set; } = string.Empty;
    }
}
