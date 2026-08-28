namespace Sagrisa.Application.DTOs.Auth
{
    public class UserProfileDto
    {
        public Guid Id { get; set; }
        public string Dui { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string? Division { get; set; }
        public string? Pais { get; set; }
        public string? CodVendedor { get; set; }
        public string? Cargo { get; set; }
        public string? Email { get; set; }
        public string? DocPersonal { get; set; }
        public string Rol { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public bool IsOfflineCapable { get; set; }
    }
}
