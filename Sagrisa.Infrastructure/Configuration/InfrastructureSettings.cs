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

    public class SupabaseSettings
    {
        public const string SectionName = "Supabase";

        public string Url { get; set; } = string.Empty;
        public string AnonKey { get; set; } = string.Empty;
        public string ServiceRoleKey { get; set; } = string.Empty;
        public string WebhookSecret { get; set; } = string.Empty;
    }
}
