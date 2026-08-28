using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Sagrisa.API.Middlewares;
using Sagrisa.Infrastructure;
using Sagrisa.API.Health;
using Sagrisa.Infrastructure.Configuration;

var builder = WebApplication.CreateBuilder(args);

// 1. Inyeccion de dependencias de Infrastructure (Repositorios, Seguridad, Servicios de Negocio)
builder.Services.AddInfrastructure(builder.Configuration);

// 2. Configuracion de Controladores y formateo JSON
builder.Services.AddControllers();

// 3. Configuracion de Autenticacion JWT
var jwtSection = builder.Configuration.GetSection(JwtSettings.SectionName);
var jwtSettings = jwtSection.Get<JwtSettings>() ?? new JwtSettings();
var databaseProvider = builder.Configuration["Database:Provider"] ?? "Postgres";
if (builder.Environment.IsProduction())
{
    if (string.IsNullOrWhiteSpace(jwtSettings.SecretKey) || jwtSettings.SecretKey.Length < 32)
        throw new InvalidOperationException("JwtSettings:SecretKey debe configurarse en Azure y tener al menos 32 caracteres.");
    if (string.IsNullOrWhiteSpace(jwtSettings.Issuer) || string.IsNullOrWhiteSpace(jwtSettings.Audience))
        throw new InvalidOperationException("JwtSettings:Issuer y JwtSettings:Audience son obligatorios en producción.");
    if (string.Equals(databaseProvider, "InMemory", StringComparison.OrdinalIgnoreCase))
        throw new InvalidOperationException("La API no puede usar Database:Provider=InMemory en producción.");
}
var key = Encoding.UTF8.GetBytes(jwtSettings.SecretKey);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = !builder.Environment.IsDevelopment();
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = true,
        ValidIssuer = jwtSettings.Issuer,
        ValidateAudience = true,
        ValidAudience = jwtSettings.Audience,
        ClockSkew = TimeSpan.Zero
    };
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin", "Gerente"));
    options.AddPolicy("Ventas", policy => policy.RequireRole("Vendedor", "Supervisor", "Gerente", "Admin"));
});

// 4. Configuracion de CORS para PWA (Vercel, Localhost, etc.)
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        var configured = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
        var origins = configured.Length > 0
            ? configured
            : ["https://sagrissa.vercel.app", "http://localhost:5173", "http://127.0.0.1:5173"];
        policy.WithOrigins(origins).AllowAnyHeader().AllowAnyMethod();
    });
});

// 5. Health checks para Azure App Service y pruebas del prototipo.
var healthChecks = builder.Services.AddHealthChecks();
if (!string.Equals(databaseProvider, "InMemory", StringComparison.OrdinalIgnoreCase)) healthChecks.AddCheck<SupabaseHealthCheck>("supabase-database");

// 6. Swagger con soporte de Authorization Bearer Token
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "SAGRISA API",
        Version = "v1",
        Description = "API de Integración y Servicios Comerciales SAGRISA (PWA + Supabase + Dynamics GP)"
    });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "Autenticación JWT usando el esquema Bearer. Ejemplo: 'Bearer {token}'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

var app = builder.Build();

// 7. Manejo de encabezados proxy de Azure App Service.
app.UseForwardedHeaders(new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
});

// 8. Middleware global de captura de excepciones
app.UseMiddleware<ExceptionMiddleware>();

// 9. Documentacion OpenAPI / Swagger en la raiz
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "SAGRISA API v1");
    c.RoutePrefix = string.Empty;
});

// 10. CORS
app.UseCors();

// 11. Autenticacion y Autorizacion
app.UseAuthentication();
app.UseAuthorization();

// 12. Health Check Endpoint
app.MapHealthChecks("/health");

// 13. Mapeo de Controladores
app.MapControllers();

app.Run();
