namespace Sagrisa.Domain.Entities
{
    public class Aprobacion
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string? NumPedido { get; set; }
        public string CodCliente { get; set; } = string.Empty;
        public string? CodVendedor { get; set; }
        public decimal Monto { get; set; }
        public string Motivo { get; set; } = string.Empty;
        public string? Detalles { get; set; }
        public string Estado { get; set; } = "pending";
        public Guid? DecididoPor { get; set; }
        public string? ComentarioDecision { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
