using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    public class ProductoRepository : IProductoRepository
    {
        private static readonly List<Producto> _productos =
        [
            new Producto
            {
                Id = Guid.Parse("aaaaaaaa-1111-1111-1111-111111111111"),
                Codigo = "P001",
                Nombre = "Aceite Vegetal 1L",
                Descripcion = "Aceite vegetal 100% puro para cocina",
                Familia = "Abarrotes",
                Division = "Agrícola",
                Presentacion = "Unidad",
                Precio = 10.50m,
                Stock = 250,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Id = Guid.Parse("bbbbbbbb-2222-2222-2222-222222222222"),
                Codigo = "P002",
                Nombre = "Arroz Premium 5lb",
                Descripcion = "Arroz grano entero seleccionado",
                Familia = "Granos Básicos",
                Division = "Agrícola",
                Presentacion = "Bolsa",
                Precio = 10.50m,
                Stock = 500,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Id = Guid.Parse("cccccccc-3333-3333-3333-333333333333"),
                Codigo = "P003",
                Nombre = "Cafe Molido 1lb",
                Descripcion = "Café arábica de altura tostado medio",
                Familia = "Bebidas",
                Division = "Industrial",
                Presentacion = "Paquete",
                Precio = 8.75m,
                Stock = 120,
                Bodega = "B02",
                Activo = true
            },
            new Producto
            {
                Id = Guid.Parse("dddddddd-4444-4444-4444-444444444444"),
                Codigo = "P004",
                Nombre = "Jabon en Barra",
                Descripcion = "Jabón multiusos para lavado",
                Familia = "Limpieza",
                Division = "Veterinaria",
                Presentacion = "Unidad",
                Precio = 5.78m,
                Stock = 300,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Id = Guid.Parse("eeeeeeee-5555-5555-5555-555555555555"),
                Codigo = "P005",
                Nombre = "Producto Descontinuado",
                Descripcion = "Item fuera de catalogo",
                Familia = "Varios",
                Division = "Taller",
                Presentacion = "Caja",
                Precio = 15.00m,
                Stock = 0,
                Bodega = "B03",
                Activo = false
            }
        ];

        public Task<IReadOnlyCollection<Producto>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Producto>>(_productos);
        }

        public Task<PagedResult<Producto>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? familia, bool? soloActivos, string? query, CancellationToken cancellationToken = default)
        {
            var queryable = _productos.AsQueryable();

            if (soloActivos.HasValue && soloActivos.Value)
            {
                queryable = queryable.Where(p => p.Activo);
            }

            if (!string.IsNullOrWhiteSpace(familia))
            {
                queryable = queryable.Where(p => string.Equals(p.Familia, familia.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            if (!string.IsNullOrWhiteSpace(query))
            {
                var q = query.Trim();
                queryable = queryable.Where(p =>
                    (p.Nombre != null && p.Nombre.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (p.Codigo != null && p.Codigo.Contains(q, StringComparison.OrdinalIgnoreCase)) ||
                    (p.Descripcion != null && p.Descripcion.Contains(q, StringComparison.OrdinalIgnoreCase)));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Producto>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Producto?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo)) return Task.FromResult<Producto?>(null);

            var producto = _productos.FirstOrDefault(p =>
                string.Equals(p.Codigo, codigo.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(producto);
        }

        public Task<Producto?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var producto = _productos.FirstOrDefault(p => p.Id == id);
            return Task.FromResult(producto);
        }
        public Task<Producto> CrearAsync(Producto producto, CancellationToken cancellationToken = default)
        {
            _productos.Add(producto);
            return Task.FromResult(producto);
        }

        public Task<Producto?> ActualizarAsync(string codigo, Producto producto, CancellationToken cancellationToken = default)
        {
            var current = _productos.FirstOrDefault(x => string.Equals(x.Codigo, codigo.Trim(), StringComparison.OrdinalIgnoreCase));
            if (current is null) return Task.FromResult<Producto?>(null);
            current.Nombre = producto.Nombre; current.Descripcion = producto.Descripcion; current.Familia = producto.Familia;
            current.Presentacion = producto.Presentacion; current.Precio = producto.Precio; current.Stock = producto.Stock;
            current.Bodega = producto.Bodega; current.Division = producto.Division; current.Activo = producto.Activo;
            return Task.FromResult<Producto?>(current);
        }
    }
}
