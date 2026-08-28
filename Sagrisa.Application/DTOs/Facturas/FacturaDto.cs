using Sagrisa.Domain.Enums;

namespace Sagrisa.Application.DTOs.Facturas
{
    public class FacturaDto
    {
        public Guid Id { get; set; }
        public string NumFactura { get; set; } = string.Empty;
        public Guid? OrderId { get; set; }
        public string CodCliente { get; set; } = string.Empty;
        public DateTime FechaEmision { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public decimal TotalFactura { get; set; }
        public decimal Saldo { get; set; }
        public InvoiceStatus Status { get; set; }
        public string? PdfUrl { get; set; }
    }
}
