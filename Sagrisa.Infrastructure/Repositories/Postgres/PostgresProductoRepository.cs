using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresProductoRepository(SagrisaDbContext db) : IProductoRepository
{
    public Task<IReadOnlyCollection<Producto>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        => ObtenerQuery().OrderBy(x => x.Nombre).ToListAsync(cancellationToken)
            .ContinueWith(x => (IReadOnlyCollection<Producto>)x.Result, cancellationToken);

    public async Task<PagedResult<Producto>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? familia, bool? soloActivos, string? query, CancellationToken cancellationToken = default)
    {
        var source = ObtenerQuery();
        if (!string.IsNullOrWhiteSpace(familia))
            source = source.Where(x => x.Familia == familia.Trim());
        if (soloActivos == true)
            source = source.Where(x => x.Activo);

        if (!string.IsNullOrWhiteSpace(query))
        {
            var value = query.Trim();
            source = source.Where(x =>
                EF.Functions.ILike(x.Nombre, $"%{value}%") ||
                EF.Functions.ILike(x.Codigo, $"%{value}%") ||
                (x.Descripcion != null && EF.Functions.ILike(x.Descripcion, $"%{value}%")));
        }

        var total = await source.CountAsync(cancellationToken);
        var items = await source.OrderBy(x => x.Nombre)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<Producto>
        {
            Items = items,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = total
        };
    }

    public Task<Producto?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        => ObtenerQuery().FirstOrDefaultAsync(x => x.Codigo == codigo.Trim(), cancellationToken);

    public Task<Producto?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        => ObtenerQuery().FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    public async Task<Producto> CrearAsync(Producto producto, CancellationToken cancellationToken = default)
    {
        if (producto.Id == Guid.Empty) producto.Id = Guid.NewGuid();
        producto.CreatedAt = DateTime.UtcNow;
        db.Productos.Add(producto);
        await db.SaveChangesAsync(cancellationToken);
        return producto;
    }

    public async Task<Producto?> ActualizarAsync(string codigo, Producto producto, CancellationToken cancellationToken = default)
    {
        var current = await db.Productos.FirstOrDefaultAsync(x => x.Codigo == codigo.Trim(), cancellationToken);
        if (current is null) return null;
        current.Nombre = producto.Nombre; current.Descripcion = producto.Descripcion; current.Familia = producto.Familia;
        current.Presentacion = producto.Presentacion; current.Precio = producto.Precio; current.Stock = producto.Stock;
        current.Bodega = producto.Bodega; current.Activo = producto.Activo;
        await db.SaveChangesAsync(cancellationToken);
        return current;
    }
    private IQueryable<Producto> ObtenerQuery() => db.Productos.AsNoTracking();
}
