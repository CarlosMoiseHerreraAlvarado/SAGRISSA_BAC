namespace Sagrisa.Application.DTOs.Usuarios
{
    public class UsuarioDto
    {
        public Guid Id { get; set; }
        public string Dui { get; set; } = string.Empty;
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
    }

    // Alias para no romper codigo legacy que importaba UsuarioDTO en mayusculas
    public class UsuarioDTO : UsuarioDto { }
}
