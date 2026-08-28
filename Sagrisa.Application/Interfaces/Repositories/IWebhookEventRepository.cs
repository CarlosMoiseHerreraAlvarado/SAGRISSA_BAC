using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Repositories
{
    public interface IWebhookEventRepository
    {
        Task<WebhookEvent> IniciarAsync(string source, string eventKey, string eventType, string payload, CancellationToken cancellationToken = default);
        Task MarcarProcesadoAsync(Guid id, CancellationToken cancellationToken = default);
        Task MarcarFallidoAsync(Guid id, string error, CancellationToken cancellationToken = default);
    }
}
