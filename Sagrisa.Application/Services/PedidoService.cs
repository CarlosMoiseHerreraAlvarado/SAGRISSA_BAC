using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;

namespace Sagrisa.Application.Services;

public class PedidoService : IPedidoService
{
    private readonly IPedidoRepository _pedidoRepository;
    private readonly IClienteRepository _clienteRepository;
    private readonly IProductoRepository _productoRepository;
    private readonly IUsuarioRepository? _usuarioRepository;
    private readonly IAprobacionRepository? _aprobacionRepository;

    public PedidoService(IPedidoRepository pedidoRepository, IClienteRepository clienteRepository, IProductoRepository productoRepository, IUsuarioRepository? usuarioRepository = null, IAprobacionRepository? aprobacionRepository = null)
    {
        _pedidoRepository = pedidoRepository;
        _clienteRepository = clienteRepository;
        _productoRepository = productoRepository;
        _usuarioRepository = usuarioRepository;
        _aprobacionRepository = aprobacionRepository;
    }

    public async Task<ApiResponse<IReadOnlyCollection<PedidoEncabezadoDto>>> ObtenerTodosAsync(CancellationToken cancellationToken = default)
    {
        var pedidos = await _pedidoRepository.ObtenerTodosAsync(cancellationToken);
        return ApiResponse<IReadOnlyCollection<PedidoEncabezadoDto>>.Ok(pedidos.Select(MapToEncabezadoDto).ToList());
    }

    public async Task<ApiResponse<PagedResult<PedidoEncabezadoDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? codVendedor = null, string? codCliente = null, CancellationToken cancellationToken = default)
    {
        var paged = await _pedidoRepository.ObtenerPaginadoAsync(filter.PageNumber, filter.PageSize, codVendedor, codCliente, cancellationToken);
        return ApiResponse<PagedResult<PedidoEncabezadoDto>>.Ok(new PagedResult<PedidoEncabezadoDto>
        {
            Items = paged.Items.Select(MapToEncabezadoDto).ToList(), PageNumber = paged.PageNumber, PageSize = paged.PageSize, TotalCount = paged.TotalCount
        });
    }

    public async Task<ApiResponse<PedidoDetalladoResponseDto>> ObtenerPorNumeroAsync(string numero, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(numero)) return ApiResponse<PedidoDetalladoResponseDto>.Fail("El número de pedido es obligatorio.");
        var pedido = await _pedidoRepository.ObtenerPorNumeroAsync(numero.Trim(), cancellationToken);
        return pedido is null ? ApiResponse<PedidoDetalladoResponseDto>.Fail($"Pedido '{numero}' no encontrado.") : ApiResponse<PedidoDetalladoResponseDto>.Ok(MapToDetalladoResponseDto(pedido));
    }

    public async Task<ApiResponse<PedidoDetalladoResponseDto>> CrearPedidoAsync(CrearPedidoDto request, string? codVendedorAuth = null, CancellationToken cancellationToken = default)
    {
        if (request is null || string.IsNullOrWhiteSpace(request.CodCliente)) return ApiResponse<PedidoDetalladoResponseDto>.Fail("El código de cliente es obligatorio.");
        if (request.Detalles is null || request.Detalles.Count == 0) return ApiResponse<PedidoDetalladoResponseDto>.Fail("El pedido debe contener al menos un producto.");
        if (request.Detalles.Any(x => string.IsNullOrWhiteSpace(x.CodProducto))) return ApiResponse<PedidoDetalladoResponseDto>.Fail("Cada línea debe indicar un producto.");
        if (request.Detalles.Any(x => x.Cantidad <= 0)) return ApiResponse<PedidoDetalladoResponseDto>.Fail("La cantidad de cada producto debe ser mayor que cero.");
        if (request.Detalles.Any(x => x.PrecioUnitario.HasValue && x.PrecioUnitario.Value < 0)) return ApiResponse<PedidoDetalladoResponseDto>.Fail("El precio unitario no puede ser negativo.");

        var cliente = await _clienteRepository.ObtenerPorCodigoAsync(request.CodCliente.Trim(), cancellationToken);
        if (cliente is null) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El cliente '{request.CodCliente}' no existe.");
        if (cliente.EstaInactivo) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El cliente '{request.CodCliente}' está inactivo.");
        if (cliente.EstaBloqueado) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El cliente '{request.CodCliente}' se encuentra bloqueado (HOLD) para pedidos.");

        var authenticatedSeller = FirstNonEmpty(codVendedorAuth);
        var requestedSeller = FirstNonEmpty(request.CodVendedor);
        if (authenticatedSeller is not null && requestedSeller is not null && !string.Equals(authenticatedSeller, requestedSeller, StringComparison.OrdinalIgnoreCase))
            return ApiResponse<PedidoDetalladoResponseDto>.Fail("El vendedor del pedido no coincide con la sesión activa.");
        var vendedor = authenticatedSeller ?? requestedSeller ?? FirstNonEmpty(cliente.Vendedor) ?? "PWA";
        var pedidoId = request.Id.GetValueOrDefault(Guid.NewGuid());
        var correlativo = $"ORD-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid():N}"[..25];
        var detalles = new List<PedidoDetalle>();
        decimal totalCalculado = 0m;

        foreach (var item in request.Detalles)
        {
            var producto = await _productoRepository.ObtenerPorCodigoAsync(item.CodProducto.Trim(), cancellationToken);
            if (producto is null) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El producto '{item.CodProducto}' no existe en el catálogo.");
            if (!producto.Activo) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El producto '{producto.Nombre}' ({producto.Codigo}) está inactivo/descontinuado.");
            if (item.Cantidad > producto.Stock) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"El producto '{producto.Nombre}' no tiene inventario suficiente. Disponible: {producto.Stock}.");
            var precioUnitario = item.PrecioUnitario is > 0 ? item.PrecioUnitario.Value : producto.Precio;
            var precioTotal = decimal.Round(item.Cantidad * precioUnitario, 2, MidpointRounding.AwayFromZero);
            totalCalculado += precioTotal;
            detalles.Add(new PedidoDetalle
            {
                Id = item.Id.GetValueOrDefault(Guid.NewGuid()), OrderId = pedidoId, NumPedido = correlativo, CodCliente = cliente.CodCliente,
                CodProducto = producto.Codigo, NomProducto = producto.Nombre, Presentacion = FirstNonEmpty(producto.Presentacion) ?? "Unidad",
                Cantidad = item.Cantidad, PrecioUnitario = precioUnitario, PrecioTotal = precioTotal, CodVendedor = vendedor,
                Bodega = FirstNonEmpty(item.Bodega, producto.Bodega) ?? "B01", Origen = "PWA", CreatedAt = DateTime.UtcNow
            });
        }

        var now = DateTime.UtcNow;
        var nuevoPedido = new Pedido
        {
            Id = pedidoId, NumPedido = correlativo, CodCliente = cliente.CodCliente, CodVendedor = vendedor,
            Tpago = FirstNonEmpty(request.Tpago) ?? "Contado", FechaPedido = now, FechaEntrega = NormalizeDeliveryDate(request.FechaEntrega) ?? now.AddDays(2),
            PlazoEntregaPedido = 2, Observacion = request.Observacion ?? string.Empty, TotalPedido = totalCalculado, Pais = "SV",
            DireccionEntrega = request.DireccionEntrega ?? cliente.Direccion, Latitud = request.Latitud, Longitud = request.Longitud,
            Status = OrderStatus.PendingApproval, EstCorr = "A", FechHoraInsert = now, Origen = "PWA", Estatus = "Pendiente",
            CreatedAt = now, UpdatedAt = now, Detalles = detalles
        };

        var creado = await _pedidoRepository.CrearAsync(nuevoPedido, cancellationToken);
        if (_aprobacionRepository is not null)
            await _aprobacionRepository.CrearAsync(new Aprobacion { NumPedido = creado.NumPedido, CodCliente = creado.CodCliente, CodVendedor = creado.CodVendedor, Monto = creado.TotalPedido, Motivo = "Pedido pendiente de aprobación", Detalles = $"{creado.Detalles.Count} línea(s) de pedido", Estado = "pending", CreatedAt = now }, cancellationToken);
        return ApiResponse<PedidoDetalladoResponseDto>.Ok(MapToDetalladoResponseDto(creado), "Pedido registrado exitosamente.");
    }

    public async Task<ApiResponse<PagedResult<PedidoEncabezadoDto>>> ObtenerPaginadoParaUsuarioAsync(PaginationFilter filter, string? rol, string? dui, Guid? userId, string? codVendedor, string? codCliente, CancellationToken cancellationToken = default)
    {
        var pedidos = await ObtenerAlcanceAsync(rol, dui, userId, codVendedor, cancellationToken);
        if (rol is "Admin" or "Director" or "Gerente")
        {
            if (!string.IsNullOrWhiteSpace(codVendedor))
                pedidos = pedidos.Where(x => string.Equals(x.CodVendedor, codVendedor.Trim(), StringComparison.OrdinalIgnoreCase)).ToList();
            if (!string.IsNullOrWhiteSpace(codCliente))
                pedidos = pedidos.Where(x => string.Equals(x.CodCliente, codCliente.Trim(), StringComparison.OrdinalIgnoreCase)).ToList();
        }

        if (!string.IsNullOrWhiteSpace(filter.Query))
        {
            var value = filter.Query.Trim();
            pedidos = pedidos.Where(x => x.NumPedido.Contains(value, StringComparison.OrdinalIgnoreCase)
                || x.CodCliente.Contains(value, StringComparison.OrdinalIgnoreCase)
                || x.CodVendedor.Contains(value, StringComparison.OrdinalIgnoreCase)
                || x.Estatus.Contains(value, StringComparison.OrdinalIgnoreCase)).ToList();
        }

        var page = Math.Max(1, filter.PageNumber);
        var size = Math.Clamp(filter.PageSize, 1, 100);
        var list = pedidos.OrderByDescending(x => x.FechaPedido).ToList();
        return ApiResponse<PagedResult<PedidoEncabezadoDto>>.Ok(new PagedResult<PedidoEncabezadoDto>
        {
            Items = list.Skip((page - 1) * size).Take(size).Select(MapToEncabezadoDto).ToList(),
            PageNumber = page,
            PageSize = size,
            TotalCount = list.Count
        });
    }

    public async Task<ApiResponse<PedidoDetalladoResponseDto>> ObtenerPorNumeroParaUsuarioAsync(string numero, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(numero)) return ApiResponse<PedidoDetalladoResponseDto>.Fail("El número de pedido es obligatorio.");
        var pedido = await _pedidoRepository.ObtenerPorNumeroAsync(numero.Trim(), cancellationToken);
        if (pedido is null) return ApiResponse<PedidoDetalladoResponseDto>.Fail($"Pedido '{numero}' no encontrado.");
        var allowed = await ObtenerAlcanceAsync(rol, dui, userId, codVendedor, cancellationToken);
        return allowed.Any(x => x.Id == pedido.Id)
            ? ApiResponse<PedidoDetalladoResponseDto>.Ok(MapToDetalladoResponseDto(pedido))
            : ApiResponse<PedidoDetalladoResponseDto>.Fail("El pedido no pertenece al alcance del usuario.");
    }

    private async Task<IReadOnlyCollection<Pedido>> ObtenerAlcanceAsync(string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken)
    {
        var pedidos = await _pedidoRepository.ObtenerTodosAsync(cancellationToken);
        if (rol is "Admin" or "Director" or "Gerente") return pedidos;
        if (string.Equals(rol, "Cliente", StringComparison.OrdinalIgnoreCase))
        {
            var cliente = (await _clienteRepository.ObtenerTodosAsync(cancellationToken))
                .FirstOrDefault(x => string.Equals(x.Dui, dui, StringComparison.OrdinalIgnoreCase) || (userId.HasValue && x.ProfileId == userId));
            return cliente is null ? [] : pedidos.Where(x => string.Equals(x.CodCliente, cliente.CodCliente, StringComparison.OrdinalIgnoreCase)).ToList();
        }
        if (string.Equals(rol, "Vendedor", StringComparison.OrdinalIgnoreCase))
            return string.IsNullOrWhiteSpace(codVendedor) ? [] : pedidos.Where(x => string.Equals(x.CodVendedor, codVendedor, StringComparison.OrdinalIgnoreCase)).ToList();
        if (string.Equals(rol, "Supervisor", StringComparison.OrdinalIgnoreCase) && _usuarioRepository is not null)
        {
            var users = await _usuarioRepository.ObtenerTodosAsync(cancellationToken);
            var sellers = users.Where(x => string.Equals(x.SupervisadoPor, dui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, dui, StringComparison.OrdinalIgnoreCase))
                .Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).ToHashSet(StringComparer.OrdinalIgnoreCase);
            return pedidos.Where(x => x.CodVendedor is not null && sellers.Contains(x.CodVendedor)).ToList();
        }
        return [];
    }
    private static DateTime? NormalizeDeliveryDate(DateTime? value)
    {
        if (!value.HasValue)
        {
            return null;
        }

        return value.Value.Kind switch
        {
            DateTimeKind.Utc => value.Value,
            DateTimeKind.Local => value.Value.ToUniversalTime(),
            _ => DateTime.SpecifyKind(value.Value, DateTimeKind.Utc)
        };
    }

    private static string? FirstNonEmpty(params string?[] values) => values.FirstOrDefault(x => !string.IsNullOrWhiteSpace(x))?.Trim();
    private static PedidoEncabezadoDto MapToEncabezadoDto(Pedido p) => new() { Id = p.Id, NumPedido = p.NumPedido, CodCliente = p.CodCliente, CodVendedor = p.CodVendedor, Tpago = p.Tpago, FechaPedido = p.FechaPedido.ToString("yyyy-MM-dd HH:mm:ss"), FechaEntrega = p.FechaEntrega?.ToString("yyyy-MM-dd"), PlazoEntregaPedido = p.PlazoEntregaPedido, Observacion = p.Observacion, TotalPedido = p.TotalPedido, Pais = p.Pais, IdDireccion = p.IdDireccion, DireccionEntrega = p.DireccionEntrega, Latitud = p.Latitud, Longitud = p.Longitud, Status = p.Status, IsSynced = p.IsSynced, EstCorr = p.EstCorr, FechHoraInsert = p.FechHoraInsert, Origen = p.Origen, IdBac = p.IdBac, IdClieCaf = p.IdClieCaf, EstadoBac = p.EstadoBac, OrderCaf = p.OrderCaf, Estatus = p.Estatus, NumFactura = p.NumFactura, ErrCorreo = p.ErrCorreo };
    private static PedidoDetalladoResponseDto MapToDetalladoResponseDto(Pedido p) => new() { Encabezado = MapToEncabezadoDto(p), Detalle = p.Detalles.Select(d => new PedidoDetalladoDto { Id = d.Id, OrderId = d.OrderId ?? p.Id, NumPedido = d.NumPedido, CodCliente = d.CodCliente, CodProducto = d.CodProducto, NomProducto = d.NomProducto, Presentacion = d.Presentacion, Cantidad = d.Cantidad, PrecioUnitario = d.PrecioUnitario, PrecioTotal = d.PrecioTotal, CodVendedor = d.CodVendedor, Bodega = d.Bodega, Origen = d.Origen }).ToList() };
}
