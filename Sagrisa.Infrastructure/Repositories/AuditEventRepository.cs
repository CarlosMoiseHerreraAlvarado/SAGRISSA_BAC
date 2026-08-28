using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories;

public sealed class AuditEventRepository : IAuditEventRepository
{
    private static readonly List<AuditEvent> Items = [];

    public Task RegistrarAsync(AuditEvent auditEvent, CancellationToken cancellationToken = default)
    {
        Items.Insert(0, auditEvent);
        return Task.CompletedTask;
    }
}
