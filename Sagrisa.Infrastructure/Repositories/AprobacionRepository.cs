using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories;

public sealed class AprobacionRepository : IAprobacionRepository
{
    private static readonly List<Aprobacion> Items = [];

    public Task<IReadOnlyCollection<Aprobacion>> ObtenerPendientesAsync(CancellationToken cancellationToken = default)
        => Task.FromResult<IReadOnlyCollection<Aprobacion>>(Items.Where(x => x.Estado == "pending").OrderByDescending(x => x.CreatedAt).ToList());

    public Task<Aprobacion?> ObtenerPorPedidoAsync(string numPedido, CancellationToken cancellationToken = default)
        => Task.FromResult(Items.FirstOrDefault(x => string.Equals(x.NumPedido, numPedido.Trim(), StringComparison.OrdinalIgnoreCase)));

    public Task<Aprobacion> CrearAsync(Aprobacion aprobacion, CancellationToken cancellationToken = default)
    {
        var existing = Items.FirstOrDefault(x => x.NumPedido is not null && string.Equals(x.NumPedido, aprobacion.NumPedido, StringComparison.OrdinalIgnoreCase));
        if (existing is not null) return Task.FromResult(existing);
        Items.Insert(0, aprobacion);
        return Task.FromResult(aprobacion);
    }

    public Task<bool> DecidirAsync(string numPedido, string estado, Guid? decididoPor, string? comentario, CancellationToken cancellationToken = default)
    {
        var item = Items.FirstOrDefault(x => string.Equals(x.NumPedido, numPedido.Trim(), StringComparison.OrdinalIgnoreCase));
        if (item is null) return Task.FromResult(false);
        item.Estado = estado;
        item.DecididoPor = decididoPor;
        item.ComentarioDecision = comentario;
        return Task.FromResult(true);
    }
}
