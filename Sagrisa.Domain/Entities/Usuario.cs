namespace Sagrisa.Domain.Entities
{
    // Representa a un usuario del sistema SAGRISA.
    // Tabla real: UsuariosMovil (no es tabla nativa de GP, es intermedia de SAGRISA).
    // Todos los campos son nullable en la tabla real (nchar/char NULL).
    // El Pin es nchar(10) en SQL Server, por eso se usa Trim() al leerlo para quitar espacios.
    public class Usuario
    {
        public string? Pin { get; set; }               // nchar(10) — siempre Trim() al leer
        public string? Nombre { get; set; }             // nchar(60)
        public string? Division { get; set; }           // nchar(30)
        public string? Pais { get; set; }               // nchar(30)
        public string? CodVendedor { get; set; }        // nchar(15)
        public string? Cargo { get; set; }              // nchar(10)
        public string? Email { get; set; }              // nchar(60)
        public string Cambiado { get; set; } = string.Empty; // nchar(1) — 'S'/'N', NO bool
        public string? Dui { get; set; }                // nchar(10)
        public string? DocPersonal { get; set; }        // nchar(13)
        public string? Token { get; set; }              // char(60) — fijo, NO unicode
        public DateTime? FechaSesion { get; set; }
        public string? GerenciadoPor { get; set; }      // nchar(15)
        public string? SupervisadoPor { get; set; }     // nchar(15)
        public string? Rol { get; set; }                // nchar(10)
    }
}
