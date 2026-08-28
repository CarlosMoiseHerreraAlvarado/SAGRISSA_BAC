using Sagrisa.Domain.Enums;

namespace Sagrisa.Domain.Entities
{
    public class Cobro
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid FacturaId { get; set; }
        public string NumFactura { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string? CodVendedor { get; set; }
        public decimal Monto { get; set; }
        public PaymentMethod MetodoPago { get; set; } = PaymentMethod.Transferencia;
        public string? Referencia { get; set; }
        public string? ComprobanteUrl { get; set; }
        public string? FirmaUrl { get; set; }
        public PaymentStatus Status { get; set; } = PaymentStatus.Pending;
        public string? Notas { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
