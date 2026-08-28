using Sagrisa.Application.DTOs.Clientes;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Services
{
    public class ClienteService : IClienteService
    {
        private readonly IClienteRepository _clienteRepository;
        private readonly IUsuarioRepository? _usuarioRepository;

        public ClienteService(IClienteRepository clienteRepository, IUsuarioRepository? usuarioRepository = null)
        {
            _clienteRepository = clienteRepository;
            _usuarioRepository = usuarioRepository;
        }

        public async Task<ApiResponse<IReadOnlyCollection<ClienteDto>>> ObtenerTodosAsync(string? vendedor = null, CancellationToken cancellationToken = default)
        {
            var clientes = string.IsNullOrWhiteSpace(vendedor)
                ? await _clienteRepository.ObtenerTodosAsync(cancellationToken)
                : await _clienteRepository.ObtenerPorVendedorAsync(vendedor.Trim(), cancellationToken);

            var dtos = clientes.Select(MapToDto).ToList();
            return ApiResponse<IReadOnlyCollection<ClienteDto>>.Ok(dtos);
        }

        public async Task<ApiResponse<PagedResult<ClienteDto>>> ObtenerPaginadoAsync(PaginationFilter filter, string? vendedor = null, CancellationToken cancellationToken = default)
        {
            var paged = await _clienteRepository.ObtenerPaginadoAsync(
                filter.PageNumber,
                filter.PageSize,
                vendedor,
                filter.Query,
                cancellationToken);

            var pagedResult = new PagedResult<ClienteDto>
            {
                Items = paged.Items.Select(MapToDto).ToList(),
                PageNumber = paged.PageNumber,
                PageSize = paged.PageSize,
                TotalCount = paged.TotalCount
            };

            return ApiResponse<PagedResult<ClienteDto>>.Ok(pagedResult);
        }

        public async Task<ApiResponse<ClienteDto>> ObtenerPorCodigoAsync(string codigo, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo))
            {
                return ApiResponse<ClienteDto>.Fail("El código de cliente es obligatorio.");
            }

            var cliente = await _clienteRepository.ObtenerPorCodigoAsync(codigo.Trim(), cancellationToken);
            if (cliente is null)
            {
                return ApiResponse<ClienteDto>.Fail($"Cliente '{codigo}' no encontrado.");
            }

            return ApiResponse<ClienteDto>.Ok(MapToDto(cliente));
        }

        public async Task<ApiResponse<PagedResult<ClienteDto>>> ObtenerPaginadoParaUsuarioAsync(PaginationFilter filter, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default)
        {
            var clientes = await ObtenerAlcanceAsync(rol, dui, userId, codVendedor, cancellationToken);
            var query = clientes.AsEnumerable();
            if (!string.IsNullOrWhiteSpace(filter.Query))
            {
                var value = filter.Query.Trim();
                query = query.Where(x => x.CodCliente.Contains(value, StringComparison.OrdinalIgnoreCase)
                    || x.NomCliente.Contains(value, StringComparison.OrdinalIgnoreCase)
                    || (x.Ciudad?.Contains(value, StringComparison.OrdinalIgnoreCase) ?? false));
            }

            var page = Math.Max(1, filter.PageNumber);
            var size = Math.Clamp(filter.PageSize, 1, 100);
            var list = query.OrderBy(x => x.NomCliente).ToList();
            return ApiResponse<PagedResult<ClienteDto>>.Ok(new PagedResult<ClienteDto>
            {
                Items = list.Skip((page - 1) * size).Take(size).Select(MapToDto).ToList(),
                PageNumber = page,
                PageSize = size,
                TotalCount = list.Count
            });
        }

        public async Task<ApiResponse<ClienteDto>> ObtenerPorCodigoParaUsuarioAsync(string codigo, string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(codigo)) return ApiResponse<ClienteDto>.Fail("El código de cliente es obligatorio.");
            var cliente = (await ObtenerAlcanceAsync(rol, dui, userId, codVendedor, cancellationToken))
                .FirstOrDefault(x => string.Equals(x.CodCliente, codigo.Trim(), StringComparison.OrdinalIgnoreCase));
            return cliente is null
                ? ApiResponse<ClienteDto>.Fail($"Cliente '{codigo}' no encontrado en el alcance del usuario.")
                : ApiResponse<ClienteDto>.Ok(MapToDto(cliente));
        }

        private async Task<IReadOnlyCollection<Cliente>> ObtenerAlcanceAsync(string? rol, string? dui, Guid? userId, string? codVendedor, CancellationToken cancellationToken)
        {
            var clientes = await _clienteRepository.ObtenerTodosAsync(cancellationToken);
            if (rol is "Admin" or "Director" or "Gerente") return clientes;
            if (string.Equals(rol, "Cliente", StringComparison.OrdinalIgnoreCase))
                return clientes.Where(x => string.Equals(x.Dui, dui, StringComparison.OrdinalIgnoreCase) || (userId.HasValue && x.ProfileId == userId)).ToList();
            if (string.Equals(rol, "Vendedor", StringComparison.OrdinalIgnoreCase))
                return string.IsNullOrWhiteSpace(codVendedor) ? [] : clientes.Where(x => string.Equals(x.Vendedor, codVendedor, StringComparison.OrdinalIgnoreCase)).ToList();
            if (string.Equals(rol, "Supervisor", StringComparison.OrdinalIgnoreCase) && _usuarioRepository is not null)
            {
                var users = await _usuarioRepository.ObtenerTodosAsync(cancellationToken);
                var sellers = users.Where(x => string.Equals(x.SupervisadoPor, dui, StringComparison.OrdinalIgnoreCase) || string.Equals(x.GerenciadoPor, dui, StringComparison.OrdinalIgnoreCase))
                    .Select(x => x.CodVendedor).Where(x => !string.IsNullOrWhiteSpace(x)).ToHashSet(StringComparer.OrdinalIgnoreCase);
                return clientes.Where(x => x.Vendedor is not null && sellers.Contains(x.Vendedor)).ToList();
            }
            return [];
        }
        private static ClienteDto MapToDto(Cliente c) => new()
        {
            CodCliente = c.CodCliente,
            ProfileId = c.ProfileId,
            NomCliente = c.NomCliente,
            Dui = c.Dui,
            Clase = c.Clase,
            Vendedor = c.Vendedor,
            Ciudad = c.Ciudad,
            Direccion = c.Direccion,
            Telefono = c.Telefono,
            TPago = c.TPago,
            INACTIVE = c.INACTIVE,
            HOLD = c.HOLD,
            LPrecios = c.LPrecios,
            MontoCredito = c.MontoCredito,
            TotalDeuda = c.TotalDeuda,
            SaldoCredito = c.SaldoCredito,
            Correo = c.Correo
        };
    }
}
