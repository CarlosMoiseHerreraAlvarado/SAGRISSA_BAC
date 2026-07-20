using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Clientes;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    // Controlador que maneja las peticiones relacionadas con clientes.
    // Ruta base: /api/clientes
    // Permite listar todos los clientes, filtrar por vendedor, o buscar uno especifico por codigo.
    [Route("clientes")]
    public class ClientesController : SagrisaBaseController
    {
        private readonly IClienteRepository _clienteRepository;

        public ClientesController(IClienteRepository clienteRepository)
        {
            _clienteRepository = clienteRepository;
        }

        // GET /api/clientes
        // Devuelve todos los clientes, o solo los de un vendedor si se envia el parametro ?vendedor=GTCMARCOS
        [HttpGet]
        public async Task<IActionResult> ObtenerTodos(
            [FromQuery] string? vendedor,
            CancellationToken cancellationToken)
        {
            // Si se envia un vendedor, filtra solo los clientes de ese vendedor.
            // Si no se envia, devuelve todos.
            var clientes = string.IsNullOrWhiteSpace(vendedor)
                ? await _clienteRepository.ObtenerTodosAsync(cancellationToken)
                : await _clienteRepository.ObtenerPorVendedorAsync(vendedor, cancellationToken);

            var resultado = clientes.Select(c => new ClienteDto
            {
                CodCliente = c.CodCliente,
                NomCliente = c.NomCliente,
                Clase = c.Clase,
                Vendedor = c.Vendedor,
                Ciudad = c.Ciudad,
                TPago = c.TPago,
                INACTIVE = c.INACTIVE,
                HOLD = c.HOLD,
                LPrecios = c.LPrecios,
                MontoCredito = c.MontoCredito,
                TotalDeuda = c.TotalDeuda,
                SaldoCredito = c.SaldoCredito,
                Correo = c.Correo
            }).ToList();

            return Ok(resultado);
        }

        // GET /api/clientes/C001
        // Devuelve un solo cliente buscado por su codigo.
        // Si no lo encuentra, devuelve un error 404 con un mensaje claro.
        [HttpGet("{codigo}")]
        public async Task<IActionResult> ObtenerPorCodigo(string codigo, CancellationToken cancellationToken)
        {
            var cliente = await _clienteRepository.ObtenerPorCodigoAsync(codigo, cancellationToken);

            if (cliente is null)
                return NotFound(new { Success = false, Message = $"Cliente '{codigo}' no encontrado." });

            var resultado = new ClienteDto
            {
                CodCliente = cliente.CodCliente,
                NomCliente = cliente.NomCliente,
                Clase = cliente.Clase,
                Vendedor = cliente.Vendedor,
                Ciudad = cliente.Ciudad,
                TPago = cliente.TPago,
                INACTIVE = cliente.INACTIVE,
                HOLD = cliente.HOLD,
                LPrecios = cliente.LPrecios,
                MontoCredito = cliente.MontoCredito,
                TotalDeuda = cliente.TotalDeuda,
                SaldoCredito = cliente.SaldoCredito,
                Correo = cliente.Correo
            };

            return Ok(resultado);
        }
    }
}
