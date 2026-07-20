using System.Net;
using System.Text.Json;

namespace Sagrisa.API.Middlewares
{
    // Middleware global que captura cualquier excepcion no controlada en los controladores.
    // En lugar de que la API devuelva un 500 con stack trace (que es un riesgo de seguridad),
    // devuelve un JSON con el codigo de error y un mensaje generico.
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _siguiente;
        private readonly ILogger<ExceptionMiddleware> _logger;

        public ExceptionMiddleware(RequestDelegate siguiente, ILogger<ExceptionMiddleware> logger)
        {
            _siguiente = siguiente;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _siguiente(context);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Excepcion no controlada: {Message}", ex.Message);
                await ManejarExcepcionAsync(context, ex);
            }
        }

        private static async Task ManejarExcepcionAsync(HttpContext context, Exception ex)
        {
            context.Response.ContentType = "application/json";

            var (statusCode, mensaje) = ex switch
            {
                ArgumentException => (HttpStatusCode.BadRequest, "Solicitud invalida."),
                KeyNotFoundException => (HttpStatusCode.NotFound, "Recurso no encontrado."),
                UnauthorizedAccessException => (HttpStatusCode.Unauthorized, "No autorizado."),
                _ => (HttpStatusCode.InternalServerError, "Error interno del servidor.")
            };

            context.Response.StatusCode = (int)statusCode;

            var respuesta = new
            {
                codigo = (int)statusCode,
                mensaje
            };

            var json = JsonSerializer.Serialize(respuesta, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            await context.Response.WriteAsync(json);
        }
    }
}
