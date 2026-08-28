using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [Route("api/[controller]")]
    public class AuthController : SagrisaBaseController
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        /// <summary>
        /// Inicia sesión validando DUI y PIN, devolviendo un Token JWT firmado con los claims del usuario.
        /// </summary>
        [HttpPost("login")]
        [AllowAnonymous]
        [ProducesResponseType(typeof(ApiResponse<LoginResponse>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<LoginResponse>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<LoginResponse>), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return BadRequest(ApiResponse<LoginResponse>.Fail("Datos de solicitud inválidos.", errors));
            }

            var result = await _authService.LoginAsync(request, cancellationToken);
            return HandleResponse(result);
        }

        /// <summary>
        /// Obtiene los datos del perfil del usuario actualmente autenticado según su token JWT.
        /// </summary>
        [HttpGet("me")]
        [Authorize]
        [ProducesResponseType(typeof(ApiResponse<UserProfileDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> Me(CancellationToken cancellationToken)
        {
            if (CurrentUserId.HasValue)
            {
                var result = await _authService.GetProfileAsync(CurrentUserId.Value, cancellationToken);
                return HandleResponse(result);
            }

            if (!string.IsNullOrEmpty(CurrentUserDui))
            {
                var result = await _authService.GetProfileByDuiAsync(CurrentUserDui, cancellationToken);
                return HandleResponse(result);
            }

            return Unauthorized(ApiResponse<UserProfileDto>.Fail("Sesión inválida o expirada."));
        }

        /// <summary>
        /// Permite al usuario autenticado cambiar su PIN de acceso de forma segura.
        /// </summary>
        [HttpPost("change-pin")]
        [Authorize]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangePin([FromBody] ChangePinRequest request, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return BadRequest(ApiResponse.Fail("Datos de solicitud inválidos.", errors));
            }

            if (!CurrentUserId.HasValue)
            {
                return Unauthorized(ApiResponse.Fail("Usuario no autenticado."));
            }

            var result = await _authService.ChangePinAsync(CurrentUserId.Value, request, cancellationToken);
            return HandleResponse(result);
        }
    }
}
