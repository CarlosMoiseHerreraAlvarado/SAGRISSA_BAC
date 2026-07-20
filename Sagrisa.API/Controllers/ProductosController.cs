using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Productos;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    // Controlador que maneja las peticiones relacionadas con productos.
    // Ruta base: /api/productos
    // Permite listar todos los productos o buscar uno especifico por codigo.
    [Route("productos")]
    public class ProductosController : SagrisaBaseController
    {
        private readonly IProductoRepository _productoRepository;

        public ProductosController(IProductoRepository productoRepository)
        {
            _productoRepository = productoRepository;
        }

        // GET /api/productos
        // Devuelve la lista completa de productos del catalogo.
        [HttpGet]
        public async Task<IActionResult> ObtenerTodos(CancellationToken cancellationToken)
        {
            var productos = await _productoRepository.ObtenerTodosAsync(cancellationToken);

            var resultado = productos.Select(p => new ProductoDto
            {
                Codigo = p.Codigo,
                Nombre = p.Nombre,
                Presentacion = p.Presentacion,
                Precio = p.Precio,
                Bodega = p.Bodega,
                Activo = p.Activo
            }).ToList();

            return Ok(resultado);
        }

        // GET /api/productos/P001
        // Devuelve un solo producto buscado por su codigo.
        // Si no lo encuentra, devuelve un error 404.
        [HttpGet("{codigo}")]
        public async Task<IActionResult> ObtenerPorCodigo(string codigo, CancellationToken cancellationToken)
        {
            var producto = await _productoRepository.ObtenerPorCodigoAsync(codigo, cancellationToken);

            if (producto is null)
                return NotFound(new { Success = false, Message = $"Producto '{codigo}' no encontrado." });

            var resultado = new ProductoDto
            {
                Codigo = producto.Codigo,
                Nombre = producto.Nombre,
                Presentacion = producto.Presentacion,
                Precio = producto.Precio,
                Bodega = producto.Bodega,
                Activo = producto.Activo
            };

            return Ok(resultado);
        }
    }
}
