using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresClienteRepository(SagrisaDbContext db) : IClienteRepository
{
    public Task<IReadOnlyCollection<Cliente>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        => ObtenerQuery().OrderBy(x => x.NomCliente).ToListAsync(cancellationToken)
            .ContinueWith(x => (IReadOnlyCollection<Cliente>)x.Result, cancellationToken);

    public async Task<PagedResult<Cliente>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? vendedor, string? query, CancellationToken cancellationToken = default)
    {
        var source = ObtenerQuery();
        if (!string.IsNullOrWhiteSpace(vendedor))
            source = source.Where(x => x.Vendedor == vendedor.Trim());

        if (!string.IsNullOrWhiteSpace(query))
        {
            var value = query.Trim();
            source = source.Where(x =>
                EF.Functions.Like(x.NomCliente, $"%{value}%") ||
                EF.Functions.Like(x.CodCliente, $"%{value}%") ||
                (x.Ciudad != null && EF.Functions.Like(x.Ciudad, $"%{value}%")));
        }

        var total = await source.CountAsync(cancellationToken);
        var items = await source.OrderBy(x => x.NomCliente)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync(cancellationToken);

        return new PagedResult<Cliente>
        {
            Items = items,
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = total
        };
    }

    public Task<Cliente?> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        => ObtenerQuery().FirstOrDefaultAsync(x => x.CodCliente == codigo.Trim(), cancellationToken);

    public Task<IReadOnlyCollection<Cliente>> ObtenerPorVendedorAsync(string codVendedor, CancellationToken cancellationToken = default)
        => ObtenerQuery().Where(x => x.Vendedor == codVendedor.Trim()).OrderBy(x => x.NomCliente)
            .ToListAsync(cancellationToken)
            .ContinueWith(x => (IReadOnlyCollection<Cliente>)x.Result, cancellationToken);

    public async Task<bool> ActualizarDeudaAsync(string codCliente, decimal montoPagado, CancellationToken cancellationToken = default)
    {
        var cliente = await db.Clientes.FirstOrDefaultAsync(x => x.CodCliente == codCliente.Trim(), cancellationToken);
        if (cliente is null) return false;

        cliente.TotalDeuda = Math.Max(0, cliente.TotalDeuda - montoPagado);
        cliente.SaldoCredito = cliente.MontoCredito - cliente.TotalDeuda;
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }

    private IQueryable<Cliente> ObtenerQuery() => db.Clientes.AsNoTracking();
}
