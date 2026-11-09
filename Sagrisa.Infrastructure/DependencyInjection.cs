using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Security;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Application.Services;
using Sagrisa.Infrastructure.Configuration;
using Sagrisa.Infrastructure.Persistence;
using Sagrisa.Infrastructure.Repositories;
using Sagrisa.Infrastructure.Repositories.Postgres;
using Sagrisa.Infrastructure.Security;

namespace Sagrisa.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            // Opciones de configuracion
            services.Configure<JwtSettings>(configuration.GetSection(JwtSettings.SectionName));
            var databaseProvider = configuration["Database:Provider"] ?? "Postgres";
            if (string.Equals(databaseProvider, "InMemory", StringComparison.OrdinalIgnoreCase))
            {
                RegisterInMemoryRepositories(services);
            }
            else if (string.Equals(databaseProvider, "Postgres", StringComparison.OrdinalIgnoreCase))
            {
                var connectionString = configuration.GetConnectionString("Postgres");
                if (string.IsNullOrWhiteSpace(connectionString))
                {
                    throw new InvalidOperationException(
                        "Falta ConnectionStrings:Postgres. Configure la cadena SSL de Supabase antes de iniciar la API.");
                }

                services.AddDbContext<SagrisaDbContext>(options =>
                    options.UseNpgsql(connectionString, postgres =>
                        postgres.EnableRetryOnFailure(3, TimeSpan.FromSeconds(5), null)));

                RegisterPostgresRepositories(services);
            }
            else
            {
                throw new InvalidOperationException(
                    $"Proveedor de base de datos no soportado: '{databaseProvider}'. Use Postgres o InMemory únicamente para pruebas.");
            }

            // Servicios de Seguridad
            services.AddSingleton<IPasswordHasher, PasswordHasher>();
            services.AddScoped<IJwtTokenGenerator, JwtTokenGenerator>();

            // Servicios de Aplicacion
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IClienteService, ClienteService>();
            services.AddScoped<IProductoService, ProductoService>();
            services.AddScoped<IPedidoService, PedidoService>();

            return services;
        }

        private static void RegisterInMemoryRepositories(IServiceCollection services)
        {
            services.AddScoped<IUsuarioRepository, UsuarioRepository>();
            services.AddScoped<IClienteRepository, ClienteRepository>();
            services.AddScoped<IProductoRepository, ProductoRepository>();
            services.AddScoped<IPedidoRepository, PedidoRepository>();
            services.AddScoped<IFacturaRepository, FacturaRepository>();
            services.AddScoped<ICobroRepository, CobroRepository>();
            services.AddScoped<IAprobacionRepository, AprobacionRepository>();
            services.AddScoped<IAuditEventRepository, AuditEventRepository>();
            services.AddScoped<IWebhookEventRepository, WebhookEventRepository>();
            services.AddScoped<IMetaRepository, EmptyMetaRepository>();
        }

        private static void RegisterPostgresRepositories(IServiceCollection services)
        {
            services.AddScoped<IUsuarioRepository, PostgresUsuarioRepository>();
            services.AddScoped<IClienteRepository, PostgresClienteRepository>();
            services.AddScoped<IProductoRepository, PostgresProductoRepository>();
            services.AddScoped<IPedidoRepository, PostgresPedidoRepository>();
            services.AddScoped<IFacturaRepository, PostgresFacturaRepository>();
            services.AddScoped<ICobroRepository, PostgresCobroRepository>();
            services.AddScoped<IAprobacionRepository, PostgresAprobacionRepository>();
            services.AddScoped<IAuditEventRepository, PostgresAuditEventRepository>();
            services.AddScoped<IWebhookEventRepository, PostgresWebhookEventRepository>();
            services.AddScoped<IMetaRepository, PostgresMetaRepository>();
        }
    }
}
