using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    // Controlador de autenticacion.
    // Ruta base: /api/auth
    // Permite iniciar sesion enviando DUI y PIN.
    [Route("auth")]
    public class AuthController : SagrisaBaseController
    {
        private readonly IUsuarioRepository _usuarioRepository;

        public AuthController(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        // POST /api/auth/login
        // Recibe DUI y PIN, valida las credenciales y devuelve los datos del usuario con un token mock.
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var usuario = await _usuarioRepository.ObtenerPorDuiAsync(request.Dui, cancellationToken);

            if (usuario is null)
            {
                return Unauthorized(new { success = false, message = "DUI o PIN incorrectos." });
            }

            var pinLimpio = usuario.Pin?.Trim();
            if (pinLimpio != request.Pin)
            {
                return Unauthorized(new { success = false, message = "DUI o PIN incorrectos." });
            }

            var response = new LoginResponse
            {
                Nombre = usuario.Nombre ?? string.Empty,
                CodVendedor = usuario.CodVendedor ?? string.Empty,
                Cargo = usuario.Cargo ?? string.Empty,
                Rol = usuario.Rol ?? string.Empty,
                Token = $"MOCK-TOKEN-{Guid.NewGuid():N}"
            };

            return Ok(response);
        }
    }
}
