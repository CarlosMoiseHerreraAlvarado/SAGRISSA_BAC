using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [Authorize(Roles = "Admin,Director,Gerente")]
    [Route("api/[controller]")]
    public class UsuariosController : SagrisaBaseController
    {
        private readonly IUsuarioRepository _usuarioRepository;

        public UsuariosController(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        /// <summary>
        /// Obtiene el listado de usuarios administrativos y operativos (Protegido por Rol).
        /// Nunca expone PINs ni credenciales de seguridad.
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<PagedResult<UserProfileDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> ObtenerPaginado(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] string? query = null,
            CancellationToken cancellationToken = default)
        {
            var paged = await _usuarioRepository.ObtenerPaginadoAsync(pageNumber, pageSize, query, cancellationToken);

            var dtos = paged.Items.Select(u => new UserProfileDto
            {
                Id = u.Id,
                Dui = u.Dui,
                Nombre = u.Nombre,
                Division = u.Division,
                Pais = u.Pais,
                CodVendedor = u.CodVendedor,
                Cargo = u.Cargo,
                Email = u.Email,
                DocPersonal = u.DocPersonal,
                Rol = u.Rol,
                IsActive = u.IsActive,
                IsOfflineCapable = u.IsOfflineCapable
            }).ToList();

            var result = new PagedResult<UserProfileDto>
            {
                Items = dtos,
                PageNumber = paged.PageNumber,
                PageSize = paged.PageSize,
                TotalCount = paged.TotalCount
            };

            return Ok(ApiResponse<PagedResult<UserProfileDto>>.Ok(result));
        }

        /// <summary>
        /// Obtiene el perfil de un usuario por su DUI.
        /// </summary>
        [HttpGet("{dui}")]
        [ProducesResponseType(typeof(ApiResponse<UserProfileDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ObtenerPorDui(string dui, CancellationToken cancellationToken)
        {
            var usuario = await _usuarioRepository.ObtenerPorDuiAsync(dui, cancellationToken);
            if (usuario is null)
            {
                return NotFound(ApiResponse<UserProfileDto>.Fail($"Usuario con DUI '{dui}' no encontrado."));
            }

            var dto = new UserProfileDto
            {
                Id = usuario.Id,
                Dui = usuario.Dui,
                Nombre = usuario.Nombre,
                Division = usuario.Division,
                Pais = usuario.Pais,
                CodVendedor = usuario.CodVendedor,
                Cargo = usuario.Cargo,
                Email = usuario.Email,
                DocPersonal = usuario.DocPersonal,
                Rol = usuario.Rol,
                IsActive = usuario.IsActive,
                IsOfflineCapable = usuario.IsOfflineCapable
            };

            return Ok(ApiResponse<UserProfileDto>.Ok(dto));
        }
    }
}
