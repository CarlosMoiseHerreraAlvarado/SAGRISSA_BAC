using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresUsuarioRepository(SagrisaDbContext db) : IUsuarioRepository
{
    public async Task<IReadOnlyCollection<Usuario>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        => await db.Usuarios.AsNoTracking().OrderBy(x => x.Nombre).ToListAsync(cancellationToken);

    public async Task<PagedResult<Usuario>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? query, CancellationToken cancellationToken = default)
    {
        var source = db.Usuarios.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(query))
        {
            var value = query.Trim();
            source = source.Where(x =>
                EF.Functions.Like(x.Nombre, $"%{value}%") ||
                EF.Functions.Like(x.Dui, $"%{value}%") ||
                (x.CodVendedor != null && EF.Functions.Like(x.CodVendedor, $"%{value}%")));
        }

        var total = await source.CountAsync(cancellationToken);
        var items = await source.OrderBy(x => x.Nombre)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<Usuario>
        {
            Items = items,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = total
        };
    }

    public Task<Usuario?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        => db.Usuarios.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    public Task<Usuario?> ObtenerPorCodVendedorAsync(string codVendedor, CancellationToken cancellationToken = default)
        => db.Usuarios.AsNoTracking().FirstOrDefaultAsync(
            x => x.CodVendedor == codVendedor.Trim(), cancellationToken);

    public Task<Usuario?> ObtenerPorDuiAsync(string dui, CancellationToken cancellationToken = default)
        => db.Usuarios.AsNoTracking().FirstOrDefaultAsync(
            x => x.Dui == dui.Trim(), cancellationToken);

    public async Task<bool> ActualizarPinAsync(Guid id, string pinHash, CancellationToken cancellationToken = default)
    {
        var usuario = await db.Usuarios.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        if (usuario is null) return false;

        usuario.PinHash = pinHash;
        usuario.UpdatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }

    public async Task<Usuario> CrearAsync(Usuario usuario, CancellationToken cancellationToken = default)
    {
        if (usuario.Id == Guid.Empty) usuario.Id = Guid.NewGuid();
        db.Usuarios.Add(usuario);
        await db.SaveChangesAsync(cancellationToken);
        return usuario;
    }
}
