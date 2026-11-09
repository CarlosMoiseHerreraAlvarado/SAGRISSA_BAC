using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public abstract class SagrisaBaseController : ControllerBase
    {
        protected string? CurrentUserDui => User.FindFirst("dui")?.Value ?? User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        protected string? CurrentUserRole => User.FindFirst(ClaimTypes.Role)?.Value ?? User.FindFirst("role")?.Value;
        protected string? CurrentUserCodVendedor => User.FindFirst("codVendedor")?.Value;
        protected string? CurrentUserDivision => User.FindFirst("division")?.Value ?? User.FindFirst("area")?.Value;
        protected string? CurrentUserPais => User.FindFirst("pais")?.Value;
        protected Guid? CurrentUserId => Guid.TryParse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? User.FindFirst("sub")?.Value, out var id) ? id : null;

        protected IActionResult HandleResponse<T>(ApiResponse<T> response)
        {
            if (response.Success)
            {
                return Ok(response);
            }

            if (response.Message.Contains("no encontrado", StringComparison.OrdinalIgnoreCase))
            {
                return NotFound(response);
            }

            if (response.Message.Contains("incorrectos", StringComparison.OrdinalIgnoreCase) ||
                response.Message.Contains("no autorizado", StringComparison.OrdinalIgnoreCase))
            {
                return Unauthorized(response);
            }

            return BadRequest(response);
        }

        protected IActionResult HandleResponse(ApiResponse response)
        {
            if (response.Success)
            {
                return Ok(response);
            }

            if (response.Message.Contains("no encontrado", StringComparison.OrdinalIgnoreCase))
            {
                return NotFound(response);
            }

            return BadRequest(response);
        }
    }
}
