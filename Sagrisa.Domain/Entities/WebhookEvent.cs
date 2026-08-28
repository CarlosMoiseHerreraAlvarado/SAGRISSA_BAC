namespace Sagrisa.Domain.Entities
{
    public sealed class WebhookEvent
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Source { get; set; } = string.Empty;
        public string EventKey { get; set; } = string.Empty;
        public string EventType { get; set; } = string.Empty;
        public string Payload { get; set; } = "{}";
        public string Status { get; set; } = "processing";
        public int Attempts { get; set; }
        public DateTime ReceivedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ProcessedAt { get; set; }
        public string? LastError { get; set; }
    }
}
