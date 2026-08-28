using System.ComponentModel.DataAnnotations;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Application.DTOs.Cobros
{
    public class CobroDto
    {
        public Guid Id { get; set; }
        public Guid FacturaId { get; set; }
        public string NumFactura { get; set; } = string.Empty;
        public string CodCliente { get; set; } = string.Empty;
        public string? CodVendedor { get; set; }
        public decimal Monto { get; set; }
        public PaymentMethod MetodoPago { get; set; }
        public string? Referencia { get; set; }
        public string? ComprobanteUrl { get; set; }
        public string? FirmaUrl { get; set; }
        public PaymentStatus Status { get; set; }
        public string? Notas { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class RegistrarCobroDto
    {
        public Guid? Id { get; set; }

        [Required(ErrorMessage = "El ID de la factura es obligatorio.")]
        public Guid FacturaId { get; set; }

        [Required(ErrorMessage = "El código de cliente es obligatorio.")]
        public string CodCliente { get; set; } = string.Empty;

        public string? CodVendedor { get; set; }

        [Range(0.01, 1000000.00, ErrorMessage = "El monto a cobrar debe ser mayor a 0.")]
        public decimal Monto { get; set; }

        public PaymentMethod MetodoPago { get; set; } = PaymentMethod.Transferencia;

        public string? Referencia { get; set; }

        public string? ComprobanteUrl { get; set; }

        public string? FirmaUrl { get; set; }

        public string? Notas { get; set; }
    }
}
