namespace Sagrisa.Application.DTOs.Clientes
{
    // Objeto de transferencia que representa un cliente para el frontend.
    // INACTIVE y HOLD son int (tinyint en SQL) — 0 = activo/desbloqueado, 1 = inactivo/bloqueado.
    public class ClienteDto
    {
        public string CodCliente { get; set; } = string.Empty;
        public string NomCliente { get; set; } = string.Empty;
        public string? Clase { get; set; }
        public string? Vendedor { get; set; }
        public string? Ciudad { get; set; }
        public string? TPago { get; set; }
        public int INACTIVE { get; set; }
        public int HOLD { get; set; }
        public string? LPrecios { get; set; }
        public decimal MontoCredito { get; set; }
        public decimal TotalDeuda { get; set; }
        public decimal SaldoCredito { get; set; }
        public string? Correo { get; set; }
    }
}
