using Microsoft.Extensions.Logging;
using Sagrisa.Application.DTOs.Cobros;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.DTOs.Webhooks;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace Sagrisa.Application.Services
{
    public class SupabaseSyncService : ISupabaseSyncService
    {
        private readonly IPedidoRepository _pedidoRepository;
        private readonly ICobroRepository _cobroRepository;
        private readonly IFacturaRepository _facturaRepository;
        private readonly IClienteRepository _clienteRepository;
        private readonly ILogger<SupabaseSyncService> _logger;
        private readonly IWebhookEventRepository _webhookEventRepository;

        public SupabaseSyncService(
            IPedidoRepository pedidoRepository,
            ICobroRepository cobroRepository,
            IFacturaRepository facturaRepository,
            IClienteRepository clienteRepository,
            ILogger<SupabaseSyncService> logger,
            IWebhookEventRepository webhookEventRepository)
        {
            _pedidoRepository = pedidoRepository;
            _cobroRepository = cobroRepository;
            _facturaRepository = facturaRepository;
            _clienteRepository = clienteRepository;
            _logger = logger;
            _webhookEventRepository = webhookEventRepository;
        }

        public async Task<ApiResponse<SyncResultDto>> ProcesarWebhookPedidoAsync(SupabaseWebhookPayload<PedidoEncabezadoDto> payload, CancellationToken cancellationToken = default)
        {
            if (payload?.Record is null)
            {
                return ApiResponse<SyncResultDto>.Fail("Payload de webhook vacío o inválido.");
            }

            var pedido = payload.Record;
            _logger.LogInformation("Procesando webhook de Supabase para pedido: {NumPedido}, Tipo: {Type}", pedido.NumPedido, payload.Type);
            var rawPayload = JsonSerializer.Serialize(payload);
            var eventRecord = await _webhookEventRepository.IniciarAsync("supabase", BuildEventKey(payload.Table, pedido.NumPedido, rawPayload), "order." + payload.Type, rawPayload, cancellationToken);
            if (eventRecord.Status == "processed") return ApiResponse<SyncResultDto>.Ok(new SyncResultDto { Synced = true, EntityId = pedido.NumPedido, Message = "Evento de pedido ya procesado." });

            // Simulación de envío y sincronización con Dynamics GP / Fiscal
            var erpDocNum = $"GP-SOP-{pedido.NumPedido}";
            await _pedidoRepository.ActualizarEstadoAsync(pedido.NumPedido, "Procesado_ERP", erpDocNum, cancellationToken);

            await _webhookEventRepository.MarcarProcesadoAsync(eventRecord.Id, cancellationToken); return ApiResponse<SyncResultDto>.Ok(new SyncResultDto
            {
                Synced = true,
                EntityId = pedido.NumPedido,
                ErpReference = erpDocNum,
                Message = $"Pedido {pedido.NumPedido} sincronizado exitosamente con Dynamics GP."
            });
        }

        public async Task<ApiResponse<SyncResultDto>> ProcesarWebhookCobroAsync(SupabaseWebhookPayload<CobroDto> payload, CancellationToken cancellationToken = default)
        {
            if (payload?.Record is null)
            {
                return ApiResponse<SyncResultDto>.Fail("Payload de cobro inválido.");
            }

            var cobro = payload.Record;
            _logger.LogInformation("Procesando webhook de Supabase para cobro: Factura {NumFactura}, Monto: {Monto}", cobro.NumFactura, cobro.Monto);
            var rawPayload = JsonSerializer.Serialize(payload);
            var eventRecord = await _webhookEventRepository.IniciarAsync("supabase", BuildEventKey(payload.Table, cobro.Id.ToString(), rawPayload), "payment." + payload.Type, rawPayload, cancellationToken);
            if (eventRecord.Status == "processed") return ApiResponse<SyncResultDto>.Ok(new SyncResultDto { Synced = true, EntityId = cobro.Id.ToString(), Message = "Evento de cobro ya procesado." });


            // Supabase puede notificar la inserción antes de la aprobación. Solo un cobro aplicado afecta cartera.
            if (cobro.Status != Sagrisa.Domain.Enums.PaymentStatus.Applied)
            {
                await _webhookEventRepository.MarcarProcesadoAsync(eventRecord.Id, cancellationToken);
                return ApiResponse<SyncResultDto>.Ok(new SyncResultDto { Synced = false, EntityId = cobro.Id.ToString(), Message = "Cobro recibido y pendiente de aprobación." });
            }
            if (cobro.FacturaId == Guid.Empty) return ApiResponse<SyncResultDto>.Fail("El cobro aplicado no tiene factura asociada.");
            var existingPayment = await _cobroRepository.ObtenerPorIdAsync(cobro.Id, cancellationToken);
            if (existingPayment?.Status != Sagrisa.Domain.Enums.PaymentStatus.Applied && !await _facturaRepository.AplicarPagoAsync(cobro.FacturaId, cobro.Monto, cancellationToken)) return ApiResponse<SyncResultDto>.Fail("No se pudo aplicar el cobro a la factura.");
            if (existingPayment?.Status != Sagrisa.Domain.Enums.PaymentStatus.Applied && !string.IsNullOrEmpty(cobro.CodCliente))
            {
                await _clienteRepository.ActualizarDeudaAsync(cobro.CodCliente, cobro.Monto, cancellationToken);
            }

            await _webhookEventRepository.MarcarProcesadoAsync(eventRecord.Id, cancellationToken);
            return ApiResponse<SyncResultDto>.Ok(new SyncResultDto
            {
                Synced = true,
                EntityId = cobro.Id.ToString(),
                ErpReference = $"REC-GP-{DateTime.UtcNow:yyyyMMdd}-{new Random().Next(100, 999)}",
                Message = "Cobro aplicado y sincronizado exitosamente con cartera."
            });
        }

        private static string BuildEventKey(string table, string id, string payload)
        {
            var hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(payload)));
            var key = $"{table}:{id}:{hash}";
            return key.Length > 240 ? key[..240] : key;
        }
    }
}
