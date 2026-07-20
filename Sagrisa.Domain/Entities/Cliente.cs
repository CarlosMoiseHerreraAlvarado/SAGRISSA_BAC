namespace Sagrisa.Domain.Entities
{
    // Representa a un cliente comercial de SAGRISA.
    // Tabla real: RM00101 (tabla nativa de clientes en Dynamics GP).
    // Los nombres de columna en el mirror pueden ser los codigos GP (CUSTNMBR, CUSTNAME, etc.)
    // o nombres amigables (CodCliente, NomCliente, etc.) — pendiente de confirmar.
    // INACTIVE y HOLD son tinyint (0/1) en la tabla real, no booleanos.
    public class Cliente
    {
        public string CodCliente { get; set; } = string.Empty;
        public string NomCliente { get; set; } = string.Empty;
        public string? Clase { get; set; }
        public string? Vendedor { get; set; }
        public string? Ciudad { get; set; }
        public string? TPago { get; set; }
        public int INACTIVE { get; set; }   // tinyint 0/1 — NO bool
        public int HOLD { get; set; }       // tinyint 0/1 — NO bool
        public string? LPrecios { get; set; }
        public decimal MontoCredito { get; set; }
        public decimal TotalDeuda { get; set; }
        public decimal SaldoCredito { get; set; }
        public string? Correo { get; set; }  // origen sin confirmar — no existe en RM00101

        // Helpers de conveniencia para no regar comparaciones con 0/1 por todo el codigo.
        public bool EstaInactivo => INACTIVE == 1;
        public bool EstaBloqueado => HOLD == 1;
    }
}
