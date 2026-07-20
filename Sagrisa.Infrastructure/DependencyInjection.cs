using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Infrastructure.Repositories;

namespace Sagrisa.Infrastructure
{
    // Clase estatica que registra todos los servicios de Infrastructure en el contenedor de dependencias.
    // Se llama desde Program.cs con builder.Services.AddInfrastructure().
    // Cuando se cambie de mock a SQL Server, solo hay que cambiar las implementaciones aqui.
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            // Registra cada interfaz de repositorio con su implementacion concreta.
            // Scoped significa que se crea una nueva instancia por cada peticion HTTP.
            // Por ahora todas apuntan a repositorios mock con datos hardcodeados.
            services.AddScoped<IUsuarioRepository, UsuarioRepository>();
            services.AddScoped<IClienteRepository, ClienteRepository>();
            services.AddScoped<IPedidoRepository, PedidoRepository>();
            services.AddScoped<IProductoRepository, ProductoRepository>();

            return services;
        }
    }
}
