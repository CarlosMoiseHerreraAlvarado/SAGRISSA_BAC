using System.ComponentModel.DataAnnotations;

namespace Sagrisa.Application.DTOs.Auth
{
    // Objeto de transferencia que representa los datos que el frontend envia para iniciar sesion.
    // El frontend envia el DUI y el PIN, el backend valida y devuelve los datos del usuario.
    // Los atributos [Required] aseguran que ambos campos sean obligatorios.
    public class LoginRequest
    {
        [Required(ErrorMessage = "El DUI es obligatorio.")]
        public string Dui { get; set; } = string.Empty;

        [Required(ErrorMessage = "El PIN es obligatorio.")]
        public string Pin { get; set; } = string.Empty;
    }
}
