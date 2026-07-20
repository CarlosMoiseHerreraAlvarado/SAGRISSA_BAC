namespace Sagrisa.Domain.Entities
{
    // Representa a un usuario del sistema SAGRISA.
    // Cada vendedor tiene un registro con sus datos personales, cargo y rol.
    // El Pin es nchar(10) en SQL Server, por eso se usa Trim() al leerlo para quitar espacios.
    public class Usuario
    {
        public string Pin { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Division { get; set; } = string.Empty;
        public string Pais { get; set; } = string.Empty;
        public string CodVendedor { get; set; } = string.Empty;
        public string Cargo { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public bool Cambiado { get; set; }
        public string Dui { get; set; } = string.Empty;
        public string DocPersonal { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public DateTime? FechaSesion { get; set; }
        public string GerenciadoPor { get; set; } = string.Empty;
        public string SupervisadoPor { get; set; } = string.Empty;
        public string Rol { get; set; } = string.Empty;
    }
}
