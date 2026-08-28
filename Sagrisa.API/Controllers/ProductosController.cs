using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.DTOs.Productos;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class ProductosController : SagrisaBaseController
    {
        private readonly IProductoService _productoService;

        public ProductosController(IProductoService productoService)
        {
            _productoService = productoService;
        }

        /// <summary>
        /// Obtiene el catálogo de productos con paginación, filtros de familia y búsqueda de texto.
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<PagedResult<ProductoDto>>), StatusCodes.Status200OK)]
        public async Task<IActionResult> ObtenerPaginado(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 20,
            [FromQuery] string? familia = null,
            [FromQuery] bool? soloActivos = true,
            [FromQuery] string? query = null,
            CancellationToken cancellationToken = default)
        {
            var filter = new PaginationFilter(pageNumber, pageSize, query);
            var result = await _productoService.ObtenerPaginadoAsync(filter, familia, soloActivos, cancellationToken);
            return HandleResponse(result);
        }

        /// <summary>
        /// Obtiene los detalles de un producto por su código / SKU.
        /// </summary>
        [HttpGet("{codigo}")]
        [ProducesResponseType(typeof(ApiResponse<ProductoDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ObtenerPorCodigo(string codigo, CancellationToken cancellationToken)
        {
            var result = await _productoService.ObtenerPorCodigoAsync(codigo, cancellationToken);
            return HandleResponse(result);
        }
        [HttpPost]
        [Authorize(Roles = "Admin,Gerente")]
        public async Task<IActionResult> Crear([FromBody] ProductoUpsertDto request, CancellationToken cancellationToken)
            => HandleResponse(await _productoService.CrearAsync(request, cancellationToken));

        [HttpPut("{codigo}")]
        [Authorize(Roles = "Admin,Gerente")]
        public async Task<IActionResult> Actualizar(string codigo, [FromBody] ProductoUpsertDto request, CancellationToken cancellationToken)
            => HandleResponse(await _productoService.ActualizarAsync(codigo, request, cancellationToken));
    }
}
