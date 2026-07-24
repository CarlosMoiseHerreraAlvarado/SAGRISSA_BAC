using Sagrisa.API.Middlewares;
using Sagrisa.Infrastructure;

// Este es el punto de entrada de la aplicacion.
// Se encarga de configurar todos los servicios que la API necesita para funcionar.

var builder = WebApplication.CreateBuilder(args);

// Registra los controladores para que la API pueda recibir y responder peticiones HTTP.
builder.Services.AddControllers();

// Configura CORS para permitir el frontend web/PWA en desarrollo y produccion.
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// Activa Swagger, que es la herramienta que muestra la documentacion de los endpoints en el navegador.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Registra todos los repositorios mock de Infrastructure.
builder.Services.AddInfrastructure(builder.Configuration);

var app = builder.Build();

// Middleware global de excepciones.
app.UseMiddleware<ExceptionMiddleware>();

// Habilita Swagger siempre (en desarrollo y produccion/Render) sirviendo en la raiz '/'
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "SAGRISA API v1");
    c.RoutePrefix = string.Empty; // Muestra Swagger al abrir la URL base de Render
});

// Aplica la politica CORS configurada arriba.
app.UseCors();

// Redirige todas las peticiones HTTP a HTTPS por seguridad.
app.UseHttpsRedirection();

// Esto le dice a la API que use los controladores para manejar las peticiones.
// Sin esto, los controladores no responden ninguna ruta.
app.MapControllers();

app.Run();
