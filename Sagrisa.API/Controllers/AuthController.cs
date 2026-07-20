using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUsuarioRepository _usuarioRepository;

        public AuthController(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var usuario = await _usuarioRepository.ObtenerPorCodVendedorAsync(request.Usuario, cancellationToken);

            if (usuario is null)
            {
                return Unauthorized(new { mensaje = "Usuario o PIN incorrectos." });
            }

            var pinLimpio = usuario.Pin?.Trim();
            if (pinLimpio != request.Pin)
            {
                return Unauthorized(new { mensaje = "Usuario o PIN incorrectos." });
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
