using Sagrisa.API.Middlewares;
using Sagrisa.Infrastructure;

// Este es el punto de entrada de la aplicacion.
// Se encarga de configurar todos los servicios que la API necesita para funcionar.

var builder = WebApplication.CreateBuilder(args);

// Registra los controladores para que la API pueda recibir y responder peticiones HTTP.
builder.Services.AddControllers();

// Activa Swagger, que es la herramienta que muestra la documentacion de los endpoints en el navegador.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Registra todos los repositorios mock de Infrastructure.
// Aqui se conectan las interfaces (IUsuarioRepository, IClienteRepository, etc.)
// con sus implementaciones concretas (UsuarioRepository, ClienteRepository, etc.).
// Cuando se conecte la base de datos real, solo hay que cambiar esta linea o el contenido de AddInfrastructure.
builder.Services.AddInfrastructure(builder.Configuration);

var app = builder.Build();

// Middleware global de excepciones — debe ir primero para capturar errores de los demas middlewares.
app.UseMiddleware<ExceptionMiddleware>();

// En modo desarrollo, se muestra Swagger para poder probar los endpoints desde el navegador.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Redirige todas las peticiones HTTP a HTTPS por seguridad.
app.UseHttpsRedirection();

// Esto le dice a la API que use los controladores para manejar las peticiones.
// Sin esto, los controladores no responden ninguna ruta.
app.MapControllers();

app.Run();
