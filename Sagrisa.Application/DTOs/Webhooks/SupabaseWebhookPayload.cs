using System.Text.Json.Serialization;

namespace Sagrisa.Application.DTOs.Webhooks
{
    public class SupabaseWebhookPayload<T>
    {
        [JsonPropertyName("type")]
        public string Type { get; set; } = string.Empty; // INSERT, UPDATE, DELETE

        [JsonPropertyName("table")]
        public string Table { get; set; } = string.Empty;

        [JsonPropertyName("schema")]
        public string Schema { get; set; } = "public";

        [JsonPropertyName("record")]
        public T? Record { get; set; }

        [JsonPropertyName("old_record")]
        public T? OldRecord { get; set; }
    }

    public class SyncResultDto
    {
        public bool Synced { get; set; }
        public string EntityId { get; set; } = string.Empty;
        public string? ErpReference { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}
