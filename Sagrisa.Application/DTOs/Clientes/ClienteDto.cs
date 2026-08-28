namespace Sagrisa.Application.DTOs.Clientes
{
    public class ClienteDto
    {
        public string CodCliente { get; set; } = string.Empty;
        public Guid? ProfileId { get; set; }
        public string NomCliente { get; set; } = string.Empty;
        public string? Dui { get; set; }
        public string? Clase { get; set; }
        public string? Vendedor { get; set; }
        public string? Ciudad { get; set; }
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public string? TPago { get; set; }
        public int INACTIVE { get; set; }
        public int HOLD { get; set; }
        public string? LPrecios { get; set; }
        public decimal MontoCredito { get; set; }
        public decimal TotalDeuda { get; set; }
        public decimal SaldoCredito { get; set; }
        public string? Correo { get; set; }
        public bool Activo => INACTIVE == 0;
        public bool EstaInactivo => INACTIVE == 1;
        public bool EstaBloqueado => HOLD == 1;
    }
}
