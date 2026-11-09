using Microsoft.Extensions.Diagnostics.HealthChecks;
using Sagrisa.Infrastructure.Persistence;

namespace Sagrisa.API.Health;

public sealed class PostgresHealthCheck(SagrisaDbContext db) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            return await db.Database.CanConnectAsync(cancellationToken)
                ? HealthCheckResult.Healthy("PostgreSQL de Supabase disponible.")
                : HealthCheckResult.Unhealthy("No fue posible conectar con PostgreSQL.");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("PostgreSQL no está disponible.", ex);
        }
    }
}
