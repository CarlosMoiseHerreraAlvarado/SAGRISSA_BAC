using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Sagrisa.Application.DTOs.Cobros;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.DTOs.Webhooks;
using Sagrisa.Application.Interfaces.Services;
using System.Security.Cryptography;
using System.Text;
using Sagrisa.Domain.Common;
using Sagrisa.Infrastructure.Configuration;

namespace Sagrisa.API.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    public class WebhooksController : SagrisaBaseController
    {
        private readonly ISupabaseSyncService _syncService;
        private readonly SupabaseSettings _supabaseSettings;
        private readonly ILogger<WebhooksController> _logger;

        public WebhooksController(
            ISupabaseSyncService syncService,
            IOptions<SupabaseSettings> supabaseOptions,
            ILogger<WebhooksController> logger)
        {
            _syncService = syncService;
            _supabaseSettings = supabaseOptions.Value;
            _logger = logger;
        }

        /// <summary>
        /// Endpoint receptor de Webhook de Supabase cuando se crea o actualiza un pedido en PostgreSQL.
        /// </summary>
        [HttpPost("supabase/order-created")]
        [ProducesResponseType(typeof(ApiResponse<SyncResultDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> OrderCreated(
            [FromHeader(Name = "X-Webhook-Secret")] string? secretHeader,
            [FromBody] SupabaseWebhookPayload<PedidoEncabezadoDto> payload,
            CancellationToken cancellationToken)
        {
            if (!ValidarWebhookSecret(secretHeader))
            {
                _logger.LogWarning("Intento de webhook de pedido no autorizado");
                return Unauthorized(ApiResponse<SyncResultDto>.Fail("Firma o secreto de webhook inválido."));
            }

            var result = await _syncService.ProcesarWebhookPedidoAsync(payload, cancellationToken);
            return HandleResponse(result);
        }

        /// <summary>
        /// Endpoint receptor de Webhook de Supabase cuando se registra un cobro con comprobante/firma en PostgreSQL.
        /// </summary>
        [HttpPost("supabase/payment-created")]
        [ProducesResponseType(typeof(ApiResponse<SyncResultDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> PaymentCreated(
            [FromHeader(Name = "X-Webhook-Secret")] string? secretHeader,
            [FromBody] SupabaseWebhookPayload<CobroDto> payload,
            CancellationToken cancellationToken)
        {
            if (!ValidarWebhookSecret(secretHeader))
            {
                _logger.LogWarning("Intento de webhook de cobro no autorizado");
                return Unauthorized(ApiResponse<SyncResultDto>.Fail("Firma o secreto de webhook inválido."));
            }

            var result = await _syncService.ProcesarWebhookCobroAsync(payload, cancellationToken);
            return HandleResponse(result);
        }

        private bool ValidarWebhookSecret(string? secretHeader)
        {
            if (string.IsNullOrWhiteSpace(_supabaseSettings.WebhookSecret) || string.IsNullOrWhiteSpace(secretHeader)) return false;
            var expected = Encoding.UTF8.GetBytes(_supabaseSettings.WebhookSecret);
            var actual = Encoding.UTF8.GetBytes(secretHeader);
            return expected.Length == actual.Length && CryptographicOperations.FixedTimeEquals(expected, actual);
        }
    }
}
