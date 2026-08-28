using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [Authorize(Roles = "Cliente,Vendedor,Supervisor,Gerente,Director,Admin")]
    [Route("api/[controller]")]
    public class PedidosController : SagrisaBaseController
    {
        private readonly IPedidoService _pedidoService;

        public PedidosController(IPedidoService pedidoService)
        {
            _pedidoService = pedidoService;
        }

        /// <summary>
        /// Obtiene el historial de pedidos con paginación y filtros por cliente o vendedor.
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<PagedResult<PedidoEncabezadoDto>>), StatusCodes.Status200OK)]
        public async Task<IActionResult> ObtenerPaginado(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] string? codVendedor = null,
            [FromQuery] string? codCliente = null,
            [FromQuery] string? query = null,
            CancellationToken cancellationToken = default)
        {
            var filter = new PaginationFilter(pageNumber, pageSize, query);
            var result = await _pedidoService.ObtenerPaginadoParaUsuarioAsync(
                filter, CurrentUserRole, CurrentUserDui, CurrentUserId, CurrentUserCodVendedor,
                codCliente, cancellationToken);

            return HandleResponse(result);
        }

        /// <summary>
        /// Obtiene un pedido específico con todas sus líneas de detalle.
        /// </summary>
        [HttpGet("{numero}")]
        [ProducesResponseType(typeof(ApiResponse<PedidoDetalladoResponseDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ObtenerPorNumero(string numero, CancellationToken cancellationToken)
        {
            var result = await _pedidoService.ObtenerPorNumeroParaUsuarioAsync(numero, CurrentUserRole, CurrentUserDui, CurrentUserId, CurrentUserCodVendedor, cancellationToken);
            return HandleResponse(result);
        }

        /// <summary>
        /// Registra un nuevo pedido comercial con sus líneas de detalle.
        /// </summary>
        [HttpPost]
        [Authorize(Roles = "Vendedor,Admin")]
        [ProducesResponseType(typeof(ApiResponse<PedidoDetalladoResponseDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<PedidoDetalladoResponseDto>), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CrearPedido([FromBody] CrearPedidoDto request, CancellationToken cancellationToken)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return BadRequest(ApiResponse<PedidoDetalladoResponseDto>.Fail("Datos de pedido inválidos.", errors));
            }

            var result = await _pedidoService.CrearPedidoAsync(request, CurrentUserCodVendedor, cancellationToken);
            return HandleResponse(result);
        }
    }
}
