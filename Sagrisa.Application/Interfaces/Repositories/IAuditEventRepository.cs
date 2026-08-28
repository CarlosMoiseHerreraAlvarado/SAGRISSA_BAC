using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IAuditEventRepository
    {
        Task RegistrarAsync(AuditEvent auditEvent, CancellationToken cancellationToken = default);
    }
}
