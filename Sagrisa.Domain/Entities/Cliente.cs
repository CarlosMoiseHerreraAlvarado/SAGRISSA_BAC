namespace Sagrisa.Domain.Entities
{
    // Representa a un cliente comercial de SAGRISA.
    // Un cliente tiene datos de contacto, informacion de credito y estado (activo/inactivo/bloqueado).
    // INACTIVE indica si el cliente esta desactivado temporalmente.
    // HOLD indica si el cliente esta bloqueado por deuda o algun otro motivo.
    public class Cliente
    {
        public string CodCliente { get; set; } = string.Empty;
        public string NomCliente { get; set; } = string.Empty;
        public string Clase { get; set; } = string.Empty;
        public string Vendedor { get; set; } = string.Empty;
        public string Ciudad { get; set; } = string.Empty;
        public string TPago { get; set; } = string.Empty;
        public bool INACTIVE { get; set; }
        public bool HOLD { get; set; }
        public string LPrecios { get; set; } = string.Empty;
        public decimal MontoCredito { get; set; }
        public decimal TotalDeuda { get; set; }
        public decimal SaldoCredito { get; set; }
        public string Correo { get; set; } = string.Empty;
    }
}
