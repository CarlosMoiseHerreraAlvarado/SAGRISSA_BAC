using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories
{
    // Repositorio mock de productos.
    // Contiene 5 productos de ejemplo, incluyendo uno inactivo (descontinuado).
    // Este catalogo se usara cuando se creen pedidos y se necesite validar productos.
    public class ProductoRepository : IProductoRepository
    {
        private static readonly List<Producto> _productos =
        [
            new Producto
            {
                Codigo = "P001",
                Nombre = "Aceite Vegetal 1L",
                Presentacion = "Unidad",
                Precio = 10.50m,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Codigo = "P002",
                Nombre = "Arroz Premium 5lb",
                Presentacion = "Bolsa",
                Precio = 10.50m,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Codigo = "P003",
                Nombre = "Cafe Molido 1lb",
                Presentacion = "Paquete",
                Precio = 8.75m,
                Bodega = "B02",
                Activo = true
            },
            new Producto
            {
                Codigo = "P004",
                Nombre = "Jabon en Barra",
                Presentacion = "Unidad",
                Precio = 5.78m,
                Bodega = "B01",
                Activo = true
            },
            new Producto
            {
                Codigo = "P005",
                Nombre = "Producto Descontinuado",
                Presentacion = "Caja",
                Precio = 15.00m,
                Bodega = "B03",
                Activo = false
            }
        ];

        // Devuelve todos los productos de la lista mock.
        public Task<IReadOnlyCollection<Producto>> ObtenerTodosAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult<IReadOnlyCollection<Producto>>(_productos);
        }

        // Busca un producto por su codigo exacto.
        public Task<Producto?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken)
        {
            var producto = _productos.FirstOrDefault(p =>
                p.Codigo.Equals(codigo, StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(producto);
        }
    }
}
