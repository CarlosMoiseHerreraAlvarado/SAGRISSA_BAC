using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Repositories;

public sealed class WebhookEventRepository : IWebhookEventRepository
{
    private static readonly List<WebhookEvent> Items = [];
    private static readonly object Sync = new();

    public Task<WebhookEvent> IniciarAsync(string source, string eventKey, string eventType, string payload, CancellationToken cancellationToken = default)
    {
        lock (Sync)
        {
            var existing = Items.FirstOrDefault(x => x.Source == source && x.EventKey == eventKey);
            if (existing is not null)
            {
                if (existing.Status == "failed")
                {
                    existing.Status = "processing";
                    existing.Attempts++;
                    existing.LastError = null;
                }
                return Task.FromResult(existing);
            }

            var item = new WebhookEvent { Source = source, EventKey = eventKey, EventType = eventType, Payload = payload, Status = "processing", Attempts = 1 };
            Items.Insert(0, item);
            return Task.FromResult(item);
        }
    }

    public Task MarcarProcesadoAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var item = Items.FirstOrDefault(x => x.Id == id);
        if (item is not null) { item.Status = "processed"; item.ProcessedAt = DateTime.UtcNow; }
        return Task.CompletedTask;
    }

    public Task MarcarFallidoAsync(Guid id, string error, CancellationToken cancellationToken = default)
    {
        var item = Items.FirstOrDefault(x => x.Id == id);
        if (item is not null) { item.Status = "failed"; item.LastError = error[..Math.Min(error.Length, 1000)]; }
        return Task.CompletedTask;
    }
}
