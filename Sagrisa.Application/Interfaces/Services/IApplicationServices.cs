using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.DTOs.Clientes;
using Sagrisa.Application.DTOs.Cobros;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.DTOs.Facturas;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.DTOs.Productos;
using Sagrisa.Application.DTOs.Webhooks;
using Sagrisa.Domain.Common;

namespace Sagrisa.Application.Interfaces.Services
{
    public interface IAuthService
    {
        Task<ApiResponse<LoginResponse>> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);
        Task<ApiResponse<UserProfileDto>> GetProfileAsync(Guid userId, CancellationToken cancellationToken = default);
        Task<ApiResponse<UserProfileDto>> GetProfileByDuiAsync(string dui, CancellationToken cancellationToken = default);
        Task<ApiResponse> ChangePinAsync(Guid userId, ChangePinRequest request, CancellationToken cancellationToken = default);
    }

    public interface IClienteService
    {
        Task<ApiResponse<IReadOnlyCollection<ClienteDto>>> ObtenerTodosAsync(string? vendedor = null, CancellationToken cancellationToken = default);
        Task<ApiResponse<PagedResult<ClienteDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? vendedor = null, CancellationToken cancellationToken = default);
        Task<ApiResponse<ClienteDto>> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default);
        Task<ApiResponse<PagedResult<ClienteDto>>> ObtenerPaginadoParaUsuarioAsync(PaginationFilter filter, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default);
        Task<ApiResponse<ClienteDto>> ObtenerPorCodigoParaUsuarioAsync(string codigo, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default);
    }

    public interface IProductoService
    {
        Task<ApiResponse<IReadOnlyCollection<ProductoDto>>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<ApiResponse<PagedResult<ProductoDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? familia = null, bool? soloActivos = true, CancellationToken cancellationToken = default);
        Task<ApiResponse<ProductoDto>> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default);
        Task<ApiResponse<ProductoDto>> CrearAsync(ProductoUpsertDto request, CancellationToken cancellationToken = default);
        Task<ApiResponse<ProductoDto>> ActualizarAsync(string codigo, ProductoUpsertDto request, CancellationToken cancellationToken = default);    }

    public interface IPedidoService
    {
        Task<ApiResponse<IReadOnlyCollection<PedidoEncabezadoDto>>> ObtenerTodosAsync(CancellationToken cancellationToken = default);
        Task<ApiResponse<PagedResult<PedidoEncabezadoDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? codVendedor = null, string? codCliente = null, CancellationToken cancellationToken = default);
        Task<ApiResponse<PedidoDetalladoResponseDto>> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken = default);
        Task<ApiResponse<PedidoDetalladoResponseDto>> CrearPedidoAsync(CrearPedidoDto request, string? codVendedorAuth = null, CancellationToken cancellationToken = default);
        Task<ApiResponse<PagedResult<PedidoEncabezadoDto>>> ObtenerPaginadoParaUsuarioAsync(PaginationFilter filter, string? rol, string? dui, Guid? userId, string? codVendedor, string? codCliente, CancellationToken cancellationToken = default);
        Task<ApiResponse<PedidoDetalladoResponseDto>> ObtenerPorNumeroParaUsuarioAsync(string numero, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default);
    }

    public interface ISupabaseSyncService
    {
        Task<ApiResponse<SyncResultDto>> ProcesarWebhookPedidoAsync(SupabaseWebhookPayload<PedidoEncabezadoDto> payload, CancellationToken cancellationToken = default);
        Task<ApiResponse<SyncResultDto>> ProcesarWebhookCobroAsync(SupabaseWebhookPayload<CobroDto> payload, CancellationToken cancellationToken = default);
    }
}
