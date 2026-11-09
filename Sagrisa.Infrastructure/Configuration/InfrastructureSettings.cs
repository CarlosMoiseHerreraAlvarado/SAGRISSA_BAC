namespace Sagrisa.Infrastructure.Configuration
{
    public class JwtSettings
    {
        public const string SectionName = "JwtSettings";

        public string SecretKey { get; set; } = string.Empty;
        public string Issuer { get; set; } = "Sagrisa.API";
        public string Audience { get; set; } = "Sagrisa.PWA";
        public int ExpirationMinutes { get; set; } = 1440; // 24 horas para sesiones de vendedores
    }

}
