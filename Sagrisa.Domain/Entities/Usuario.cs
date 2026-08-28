namespace Sagrisa.Domain.Entities
{
    public class Usuario
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Dui { get; set; } = string.Empty;
        public string? Pin { get; set; }
        public string? PinHash { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Division { get; set; }
        public string? Pais { get; set; }
        public string? CodVendedor { get; set; }
        public string? Cargo { get; set; }
        public string? Email { get; set; }
        public string Cambiado { get; set; } = "N";
        public string? DocPersonal { get; set; }
        public string? Token { get; set; }
        public DateTime? FechaSesion { get; set; }
        public string? GerenciadoPor { get; set; }
        public string? SupervisadoPor { get; set; }
        public string Rol { get; set; } = "Vendedor";
        public bool IsActive { get; set; } = true;
        public bool IsOfflineCapable { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
