using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.DTOs.Productos;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Services
{
    public class ProductoService : IProductoService
    {
        private readonly IProductoRepository _productoRepository;

        public ProductoService(IProductoRepository productoRepository)
        {
            _productoRepository = productoRepository;
        }

        public async Task<ApiResponse<IReadOnlyCollection<ProductoDto>>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            var productos = await _productoRepository.ObtenerTodosAsync(cancellationToken);
            var dtos = productos.Select(MapToDto).ToList();
            return ApiResponse<IReadOnlyCollection<ProductoDto>>.Ok(dtos);
        }

        public async Task<ApiResponse<PagedResult<ProductoDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? familia = null, bool? soloActivos = true, CancellationToken cancellationToken = default)
        {
            var paged = await _productoRepository.ObtenerPaginadoAsync(
                filter.PageNumber,
                filter.PageSize,
                familia,
                soloActivos,
                filter.Query,
                cancellationToken);

            var pagedResult = new PagedResult<ProductoDto>
            {
                Items = paged.Items.Select(MapToDto).ToList(),
                PageNumber = paged.PageNumber,
                PageSize = paged.PageSize,
                TotalCount = paged.TotalCount
            };

            return ApiResponse<PagedResult<ProductoDto>>.Ok(pagedResult);
        }

        public async Task<ApiResponse<ProductoDto>> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo))
            {
                return ApiResponse<ProductoDto>.Fail("El código de producto es obligatorio.");
            }

            var producto = await _productoRepository.ObtenerPorCodigoAsync(codigo.Trim(), cancellationToken);
            if (producto is null)
            {
                return ApiResponse<ProductoDto>.Fail($"Producto '{codigo}' no encontrado.");
            }

            return ApiResponse<ProductoDto>.Ok(MapToDto(producto));
        }

        public async Task<ApiResponse<ProductoDto>> CrearAsync(ProductoUpsertDto request, CancellationToken cancellationToken = default)
        {
            if (request is null || string.IsNullOrWhiteSpace(request.Codigo) || string.IsNullOrWhiteSpace(request.Nombre))
                return ApiResponse<ProductoDto>.Fail("Código y nombre del producto son obligatorios.");
            if (request.Precio < 0 || request.Stock < 0) return ApiResponse<ProductoDto>.Fail("Precio y stock no pueden ser negativos.");
            if (await _productoRepository.ObtenerPorCodigoAsync(request.Codigo.Trim(), cancellationToken) is not null)
                return ApiResponse<ProductoDto>.Fail($"El producto '{request.Codigo}' ya existe.");
            var created = await _productoRepository.CrearAsync(ToEntity(request), cancellationToken);
            return ApiResponse<ProductoDto>.Ok(MapToDto(created), "Producto creado.");
        }

        public async Task<ApiResponse<ProductoDto>> ActualizarAsync(string codigo, ProductoUpsertDto request, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo) || request is null || string.IsNullOrWhiteSpace(request.Nombre))
                return ApiResponse<ProductoDto>.Fail("Código y nombre del producto son obligatorios.");
            if (request.Precio < 0 || request.Stock < 0) return ApiResponse<ProductoDto>.Fail("Precio y stock no pueden ser negativos.");
            var updated = await _productoRepository.ActualizarAsync(codigo.Trim(), ToEntity(request), cancellationToken);
            return updated is null
                ? ApiResponse<ProductoDto>.Fail($"Producto '{codigo}' no encontrado.")
                : ApiResponse<ProductoDto>.Ok(MapToDto(updated), "Producto actualizado.");
        }

        private static Producto ToEntity(ProductoUpsertDto request) => new()
        {
            Id = Guid.NewGuid(), Codigo = request.Codigo.Trim(), Nombre = request.Nombre.Trim(), Descripcion = request.Descripcion,
            Familia = string.IsNullOrWhiteSpace(request.Familia) ? "General" : request.Familia.Trim(),
            Presentacion = string.IsNullOrWhiteSpace(request.Presentacion) ? "Unidad" : request.Presentacion.Trim(),
            Precio = request.Precio, Stock = request.Stock,
            Bodega = string.IsNullOrWhiteSpace(request.Bodega) ? "Bodega Central" : request.Bodega.Trim(), Activo = request.Activo
        };
        private static ProductoDto MapToDto(Producto p) => new()
        {
            Id = p.Id,
            Codigo = p.Codigo,
            Nombre = p.Nombre,
            Descripcion = p.Descripcion,
            Familia = p.Familia,
            Presentacion = p.Presentacion,
            Precio = p.Precio,
            Stock = p.Stock,
            Bodega = p.Bodega,
            Activo = p.Activo
        };
    }
}
