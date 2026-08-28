using Sagrisa.Domain.Enums;

namespace Sagrisa.Domain.Entities
{
    public class Factura
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string NumFactura { get; set; } = string.Empty;
        public Guid? OrderId { get; set; }
        public string CodCliente { get; set; } = string.Empty;
        public DateTime FechaEmision { get; set; } = DateTime.UtcNow;
        public DateTime FechaVencimiento { get; set; }
        public decimal TotalFactura { get; set; }
        public decimal Saldo { get; set; }
        public InvoiceStatus Status { get; set; } = InvoiceStatus.Unpaid;
        public string? PdfUrl { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
