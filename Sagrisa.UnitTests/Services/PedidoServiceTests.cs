using Moq;
using Sagrisa.Application.DTOs.Pedidos;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Services;
using Sagrisa.Domain.Entities;

namespace Sagrisa.UnitTests.Services
{
    public class PedidoServiceTests
    {
        private readonly Mock<IPedidoRepository> _pedidoRepoMock;
        private readonly Mock<IClienteRepository> _clienteRepoMock;
        private readonly Mock<IProductoRepository> _productoRepoMock;
        private readonly PedidoService _pedidoService;

        public PedidoServiceTests()
        {
            _pedidoRepoMock = new Mock<IPedidoRepository>();
            _clienteRepoMock = new Mock<IClienteRepository>();
            _productoRepoMock = new Mock<IProductoRepository>();

            _pedidoService = new PedidoService(
                _pedidoRepoMock.Object,
                _clienteRepoMock.Object,
                _productoRepoMock.Object);
        }

        [Fact]
        public async Task CrearPedidoAsync_ClienteBloqueado_RetornaFail()
        {
            // Arrange
            var clienteBloqueado = new Cliente
            {
                CodCliente = "C004",
                HOLD = 1 // Bloqueado
            };

            _clienteRepoMock
                .Setup(r => r.ObtenerPorCodigoAsync("C004", It.IsAny<CancellationToken>()))
                .ReturnsAsync(clienteBloqueado);

            var request = new CrearPedidoDto
            {
                CodCliente = "C004",
                Detalles = [new CrearPedidoDetalleDto { CodProducto = "P001", Cantidad = 1 }]
            };

            // Act
            var result = await _pedidoService.CrearPedidoAsync(request, "GTCMARCOS", CancellationToken.None);

            // Assert
            Assert.False(result.Success);
            Assert.Contains("bloqueado", result.Message, StringComparison.OrdinalIgnoreCase);
        }

        [Fact]
        public async Task CrearPedidoAsync_ProductoInactivo_RetornaFail()
        {
            // Arrange
            var cliente = new Cliente { CodCliente = "C001", HOLD = 0, INACTIVE = 0 };
            var productoInactivo = new Producto { Codigo = "P005", Activo = false, Nombre = "Item Descontinuado" };

            _clienteRepoMock
                .Setup(r => r.ObtenerPorCodigoAsync("C001", It.IsAny<CancellationToken>()))
                .ReturnsAsync(cliente);

            _productoRepoMock
                .Setup(r => r.ObtenerPorCodigoAsync("P005", It.IsAny<CancellationToken>()))
                .ReturnsAsync(productoInactivo);

            var request = new CrearPedidoDto
            {
                CodCliente = "C001",
                Detalles = [new CrearPedidoDetalleDto { CodProducto = "P005", Cantidad = 1 }]
            };

            // Act
            var result = await _pedidoService.CrearPedidoAsync(request, "GTCMARCOS", CancellationToken.None);

            // Assert
            Assert.False(result.Success);
            Assert.Contains("inactivo", result.Message, StringComparison.OrdinalIgnoreCase);
        }
    }
}
