using System.ComponentModel.DataAnnotations;

namespace Sagrisa.Application.DTOs.Auth
{
    public class LoginRequest
    {
        [Required(ErrorMessage = "El DUI es obligatorio.")]
        public string Dui { get; set; } = string.Empty;

        [Required(ErrorMessage = "El PIN es obligatorio.")]
        [StringLength(10, MinimumLength = 4, ErrorMessage = "El PIN debe tener entre 4 y 10 caracteres.")]
        public string Pin { get; set; } = string.Empty;
    }

    public class ChangePinRequest
    {
        [Required(ErrorMessage = "El PIN actual es obligatorio.")]
        public string PinActual { get; set; } = string.Empty;

        [Required(ErrorMessage = "El nuevo PIN es obligatorio.")]
        [StringLength(10, MinimumLength = 4, ErrorMessage = "El nuevo PIN debe tener entre 4 y 10 caracteres.")]
        public string NuevoPin { get; set; } = string.Empty;
    }
}
