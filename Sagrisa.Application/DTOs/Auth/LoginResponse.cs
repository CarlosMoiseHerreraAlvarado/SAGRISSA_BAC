namespace Sagrisa.Application.DTOs.Auth
{
    public class LoginResponse
    {
        public string Token { get; set; } = string.Empty;
        public string TokenType { get; set; } = "Bearer";
        public int ExpiresIn { get; set; }
        public UserProfileDto User { get; set; } = new();

        // Propiedades de retrocompatibilidad directa
        public string Nombre => User.Nombre;
        public string CodVendedor => User.CodVendedor ?? string.Empty;
        public string Cargo => User.Cargo ?? string.Empty;
        public string Rol => User.Rol;
    }
}
