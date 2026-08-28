using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Clientes;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class ClientesController : SagrisaBaseController
    {
        private readonly IClienteService _clienteService;

        public ClientesController(IClienteService clienteService)
        {
            _clienteService = clienteService;
        }

        /// <summary>
        /// Obtiene el catálogo de clientes con paginación y búsqueda.
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<PagedResult<ClienteDto>>), StatusCodes.Status200OK)]
        public async Task<IActionResult> ObtenerPaginado(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] string? vendedor = null,
            [FromQuery] string? query = null,
            CancellationToken cancellationToken = default)
        {
            var filter = new PaginationFilter(pageNumber, pageSize, query);
            var result = await _clienteService.ObtenerPaginadoParaUsuarioAsync(
                filter, CurrentUserRole, CurrentUserDui, CurrentUserId, CurrentUserCodVendedor, cancellationToken);

            return HandleResponse(result);
        }

        /// <summary>
        /// Obtiene un cliente por su código único de Dynamics GP.
        /// </summary>
        [HttpGet("{codigo}")]
        [ProducesResponseType(typeof(ApiResponse<ClienteDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ObtenerPorCodigo(string codigo, CancellationToken cancellationToken)
        {
            var result = await _clienteService.ObtenerPorCodigoParaUsuarioAsync(codigo, CurrentUserRole, CurrentUserDui, CurrentUserId, CurrentUserCodVendedor, cancellationToken);
            return HandleResponse(result);
        }
    }
}
