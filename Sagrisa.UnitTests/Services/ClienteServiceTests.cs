using Moq;
using Sagrisa.Application.DTOs.Common;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Services;
using Sagrisa.Domain.Entities;

namespace Sagrisa.UnitTests.Services
{
    public class ClienteServiceTests
    {
        private readonly Mock<IClienteRepository> _clienteRepositoryMock;
        private readonly ClienteService _clienteService;

        public ClienteServiceTests()
        {
            _clienteRepositoryMock = new Mock<IClienteRepository>();
            _clienteService = new ClienteService(_clienteRepositoryMock.Object);
        }

        [Fact]
        public async Task ObtenerPorCodigoAsync_ClienteExiste_RetornaClienteDto()
        {
            // Arrange
            var cliente = new Cliente
            {
                CodCliente = "C001",
                NomCliente = "Distribuidora La Paz",
                Vendedor = "GTCMARCOS",
                MontoCredito = 5000m,
                TotalDeuda = 1200m,
                SaldoCredito = 3800m
            };

            _clienteRepositoryMock
                .Setup(r => r.ObtenerPorCodigoAsync("C001", It.IsAny<CancellationToken>()))
                .ReturnsAsync(cliente);

            // Act
            var result = await _clienteService.ObtenerPorCodigoAsync("C001", CancellationToken.None);

            // Assert
            Assert.True(result.Success);
            Assert.NotNull(result.Data);
            Assert.Equal("C001", result.Data.CodCliente);
            Assert.Equal("Distribuidora La Paz", result.Data.NomCliente);
        }

        [Fact]
        public async Task ObtenerPorCodigoAsync_ClienteNoExiste_RetornaFail()
        {
            // Arrange
            _clienteRepositoryMock
                .Setup(r => r.ObtenerPorCodigoAsync("INEXISTENTE", It.IsAny<CancellationToken>()))
                .ReturnsAsync((Cliente?)null);

            // Act
            var result = await _clienteService.ObtenerPorCodigoAsync("INEXISTENTE", CancellationToken.None);

            // Assert
            Assert.False(result.Success);
            Assert.Contains("no encontrado", result.Message, StringComparison.OrdinalIgnoreCase);
        }
    }
}
