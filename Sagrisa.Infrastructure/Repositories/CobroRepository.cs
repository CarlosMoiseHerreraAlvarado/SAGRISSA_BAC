using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Infrastructure.Repositories
{
    public class CobroRepository : ICobroRepository
    {
        private static readonly List<Cobro> _cobros = [];

        public Task<IReadOnlyCollection<Cobro>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Cobro>>(_cobros);
        }

        public Task<PagedResult<Cobro>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, string? codVendedor, CancellationToken cancellationToken = default)
        {
            var queryable = _cobros.AsQueryable();

            if (!string.IsNullOrWhiteSpace(codCliente))
            {
                queryable = queryable.Where(c => string.Equals(c.CodCliente, codCliente.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            if (!string.IsNullOrWhiteSpace(codVendedor))
            {
                queryable = queryable.Where(c => string.Equals(c.CodVendedor, codVendedor.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .OrderByDescending(c => c.CreatedAt)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Cobro>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Cobro?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var cobro = _cobros.FirstOrDefault(c => c.Id == id);
            return Task.FromResult(cobro);
        }

        public Task<Cobro> CrearAsync(Cobro cobro, CancellationToken cancellationToken = default)
        {
            _cobros.Insert(0, cobro);
            return Task.FromResult(cobro);
        }

        public Task<bool> ActualizarEstadoAsync(Guid id, PaymentStatus status, CancellationToken cancellationToken = default)
        {
            var cobro = _cobros.FirstOrDefault(c => c.Id == id);
            if (cobro is null) return Task.FromResult(false);

            cobro.Status = status;
            return Task.FromResult(true);
        }
    }
}
