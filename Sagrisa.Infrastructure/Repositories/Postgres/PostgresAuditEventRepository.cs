using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresAuditEventRepository(SagrisaDbContext db) : IAuditEventRepository
{
    public async Task RegistrarAsync(AuditEvent auditEvent, CancellationToken cancellationToken = default)
    {
        db.AuditEvents.Add(auditEvent);
        await db.SaveChangesAsync(cancellationToken);
    }
}
