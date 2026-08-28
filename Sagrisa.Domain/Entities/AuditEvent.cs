namespace Sagrisa.Domain.Entities
{
    public sealed class AuditEvent
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public Guid? ActorId { get; set; }
        public string Action { get; set; } = string.Empty;
        public string EntityType { get; set; } = string.Empty;
        public string? EntityId { get; set; }
        public string? BeforeData { get; set; }
        public string? AfterData { get; set; }
        public System.Net.IPAddress? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
