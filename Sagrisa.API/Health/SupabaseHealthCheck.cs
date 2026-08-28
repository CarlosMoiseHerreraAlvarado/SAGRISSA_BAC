using Microsoft.Extensions.Diagnostics.HealthChecks;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.API.Health;

public sealed class SupabaseHealthCheck(SagrisaDbContext db) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            return await db.Database.CanConnectAsync(cancellationToken)
                ? HealthCheckResult.Healthy("Supabase PostgreSQL disponible.")
                : HealthCheckResult.Unhealthy("No fue posible conectar con Supabase PostgreSQL.");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("Supabase PostgreSQL no está disponible.", ex);
        }
    }
}
