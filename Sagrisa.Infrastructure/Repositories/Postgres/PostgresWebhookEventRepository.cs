using Microsoft.EntityFrameworkCore;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.Infrastructure.Repositories.Postgres;

public sealed class PostgresWebhookEventRepository(SagrisaDbContext db) : IWebhookEventRepository
{
    public async Task<WebhookEvent> IniciarAsync(string source, string eventKey, string eventType, string payload, CancellationToken cancellationToken = default)
    {
        var existing = await db.WebhookEvents.FirstOrDefaultAsync(x => x.Source == source && x.EventKey == eventKey, cancellationToken);
        if (existing is not null)
        {
            if (existing.Status == "failed")
            {
                existing.Status = "processing";
                existing.Attempts++;
                existing.LastError = null;
                await db.SaveChangesAsync(cancellationToken);
            }
            return existing;
        }

        var item = new WebhookEvent { Source = source, EventKey = eventKey, EventType = eventType, Payload = payload, Status = "processing", Attempts = 1 };
        db.WebhookEvents.Add(item);
        try
        {
            await db.SaveChangesAsync(cancellationToken);
            return item;
        }
        catch (DbUpdateException)
        {
            db.Entry(item).State = EntityState.Detached;
            return await db.WebhookEvents.FirstAsync(x => x.Source == source && x.EventKey == eventKey, cancellationToken);
        }
    }

    public async Task MarcarProcesadoAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var item = await db.WebhookEvents.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        if (item is null) return;
        item.Status = "processed";
        item.ProcessedAt = DateTime.UtcNow;
        item.LastError = null;
        await db.SaveChangesAsync(cancellationToken);
    }

    public async Task MarcarFallidoAsync(Guid id, string error, CancellationToken cancellationToken = default)
    {
        var item = await db.WebhookEvents.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        if (item is null) return;
        item.Status = "failed";
        item.LastError = error[..Math.Min(error.Length, 1000)];
        await db.SaveChangesAsync(cancellationToken);
    }
}
