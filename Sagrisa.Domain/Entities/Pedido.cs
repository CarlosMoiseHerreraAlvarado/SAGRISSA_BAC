namespace Sagrisa.Domain.Entities
{
    // Representa el encabezado de un pedido en SAGRISA.
    // Contiene la informacion general del pedido: cliente, vendedor, fechas, totales, estado.
    // Los campos como IdBac, EstadoBac, orderCaf, idClieCaf estan pendientes de confirmar
    // si corresponden a Dynamics 365 o a otro sistema intermedio.
    // EstCorr y Estatus son dos campos de estado diferentes cuyo significado exacto esta por definir.
    public class Pedido
    {
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string CodVendedor { get; set; } = string.Empty;
        public string Tpago { get; set; } = string.Empty;
        public DateTime FechaPedido { get; set; }
        public DateTime? FechaEntrega { get; set; }
        public int PlazoEntregaPedido { get; set; }
        public string Observacion { get; set; } = string.Empty;
        public decimal TotalPedido { get; set; }
        public string Pais { get; set; } = string.Empty;
        public int? IdDireccion { get; set; }
        public string EstCorr { get; set; } = string.Empty;
        public DateTime FechHoraInsert { get; set; }
        public string Origen { get; set; } = string.Empty;
        public string IdBac { get; set; } = string.Empty;
        public string IdClieCaf { get; set; } = string.Empty;
        public string EstadoBac { get; set; } = string.Empty;
        public string OrderCaf { get; set; } = string.Empty;
        public string Estatus { get; set; } = string.Empty;
        public string NumFactura { get; set; } = string.Empty;
        public string ErrCorreo { get; set; } = string.Empty;

        // Lista de lineas de producto que componen el pedido.
        // Un pedido puede tener uno o varios productos, cada uno con su cantidad y precio.
        public List<PedidoDetalle> Detalles { get; set; } = [];
    }
}
