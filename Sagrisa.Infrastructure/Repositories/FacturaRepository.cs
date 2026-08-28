using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Infrastructure.Repositories
{
    public class FacturaRepository : IFacturaRepository
    {
        private static readonly List<Factura> _facturas =
        [
            new Factura
            {
                Id = Guid.Parse("f1111111-1111-1111-1111-111111111111"),
                NumFactura = "FAC-2026-001",
                CodCliente = "C001",
                FechaEmision = new DateTime(2026, 7, 10, 0, 0, 0, DateTimeKind.Utc),
                FechaVencimiento = new DateTime(2026, 8, 10, 0, 0, 0, DateTimeKind.Utc),
                TotalFactura = 1200.00m,
                Saldo = 1200.00m,
                Status = InvoiceStatus.Unpaid,
                PdfUrl = null
            },
            new Factura
            {
                Id = Guid.Parse("f2222222-2222-2222-2222-222222222222"),
                NumFactura = "FAC-2026-002",
                CodCliente = "C004",
                FechaEmision = new DateTime(2026, 6, 1, 0, 0, 0, DateTimeKind.Utc),
                FechaVencimiento = new DateTime(2026, 7, 1, 0, 0, 0, DateTimeKind.Utc),
                TotalFactura = 3500.00m,
                Saldo = 3500.00m,
                Status = InvoiceStatus.Overdue,
                PdfUrl = null
            }
        ];

        public Task<IReadOnlyCollection<Factura>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
        {
            return Task.FromResult<IReadOnlyCollection<Factura>>(_facturas);
        }

        public Task<PagedResult<Factura>> ObtenerPaginadoAsync(int pageNumber, int pageSize, string? codCliente, CancellationToken cancellationToken = default)
        {
            var queryable = _facturas.AsQueryable();

            if (!string.IsNullOrWhiteSpace(codCliente))
            {
                queryable = queryable.Where(f => string.Equals(f.CodCliente, codCliente.Trim(), StringComparison.OrdinalIgnoreCase));
            }

            var totalCount = queryable.Count();
            var items = queryable
                .OrderByDescending(f => f.FechaEmision)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return Task.FromResult(new PagedResult<Factura>
            {
                Items = items,
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = totalCount
            });
        }

        public Task<Factura?> ObtenerPorNumeroAsync(string numFactura, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(numFactura)) return Task.FromResult<Factura?>(null);

            var factura = _facturas.FirstOrDefault(f =>
                string.Equals(f.NumFactura, numFactura.Trim(), StringComparison.OrdinalIgnoreCase));

            return Task.FromResult(factura);
        }

        public Task<Factura?> ObtenerPorIdAsync(Guid id, CancellationToken cancellationToken = default)
        {
            var factura = _facturas.FirstOrDefault(f => f.Id == id);
            return Task.FromResult(factura);
        }

        public Task<bool> AplicarPagoAsync(Guid facturaId, decimal monto, CancellationToken cancellationToken = default)
        {
            var factura = _facturas.FirstOrDefault(f => f.Id == facturaId);
            if (factura is null) return Task.FromResult(false);

            factura.Saldo = Math.Max(0, factura.Saldo - monto);
            factura.Status = factura.Saldo == 0 ? InvoiceStatus.Paid : InvoiceStatus.Partial;

            return Task.FromResult(true);
        }
    }
}
