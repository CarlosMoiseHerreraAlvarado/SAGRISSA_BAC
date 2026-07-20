namespace Sagrisa.Application.DTOs.Auth
{
    // Objeto de transferencia que representa la respuesta exitosa de un login.
    // Contiene la informacion basica del usuario que el frontend necesita para mostrar en pantalla.
    // El Token se usara para autenticar las siguientes peticiones del usuario.
    public class LoginResponse
    {
        public string Nombre { get; set; } = string.Empty;
        public string CodVendedor { get; set; } = string.Empty;
        public string Cargo { get; set; } = string.Empty;
        public string Rol { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
    }
}
