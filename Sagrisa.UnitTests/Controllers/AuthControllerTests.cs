using Microsoft.AspNetCore.Mvc;
using Moq;
using Sagrisa.API.Controllers;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;

namespace Sagrisa.UnitTests.Controllers
{
    public class AuthControllerTests
    {
        private readonly Mock<IUsuarioRepository> _usuarioRepositoryMock;
        private readonly AuthController _controller;

        public AuthControllerTests()
        {
            _usuarioRepositoryMock = new Mock<IUsuarioRepository>();
            _controller = new AuthController(_usuarioRepositoryMock.Object);
        }

        [Fact]
        public async Task Login_CredencialesValidas_DevuelveOkConToken()
        {
            // Arrange
            var usuario = new Usuario
            {
                CodVendedor = "GTCMARCOS",
                Pin = "77777",
                Nombre = "Marcos Antonio Gutierrez",
                Cargo = "Vendedor",
                Rol = "Vendedor"
            };

            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorCodVendedorAsync("GTCMARCOS", It.IsAny<CancellationToken>()))
                .ReturnsAsync(usuario);

            var request = new LoginRequest { Usuario = "GTCMARCOS", Pin = "77777" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(resultado);
            var response = Assert.IsType<LoginResponse>(okResult.Value);
            Assert.Equal("Marcos Antonio Gutierrez", response.Nombre);
            Assert.Equal("GTCMARCOS", response.CodVendedor);
            Assert.StartsWith("MOCK-TOKEN-", response.Token);
        }

        [Fact]
        public async Task Login_PinIncorrecto_DevuelveUnauthorized()
        {
            // Arrange
            var usuario = new Usuario
            {
                CodVendedor = "GTCMARCOS",
                Pin = "77777",
                Nombre = "Marcos Antonio Gutierrez"
            };

            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorCodVendedorAsync("GTCMARCOS", It.IsAny<CancellationToken>()))
                .ReturnsAsync(usuario);

            var request = new LoginRequest { Usuario = "GTCMARCOS", Pin = "00000" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            Assert.IsType<UnauthorizedObjectResult>(resultado);
        }

        [Fact]
        public async Task Login_UsuarioNoExiste_DevuelveUnauthorized()
        {
            // Arrange
            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorCodVendedorAsync("NOEXISTE", It.IsAny<CancellationToken>()))
                .ReturnsAsync((Usuario?)null);

            var request = new LoginRequest { Usuario = "NOEXISTE", Pin = "12345" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            Assert.IsType<UnauthorizedObjectResult>(resultado);
        }

        [Fact]
        public async Task Login_ModeloInvalido_DevuelveBadRequest()
        {
            // Arrange
            _controller.ModelState.AddModelError("Usuario", "El usuario es obligatorio.");

            var request = new LoginRequest { Usuario = "", Pin = "" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            Assert.IsType<BadRequestObjectResult>(resultado);
        }

        [Fact]
        public async Task Login_PinConEspaciosEnDb_SeComparaCorrectamente()
        {
            // Arrange — simula nchar(10) que agrega espacios
            var usuario = new Usuario
            {
                CodVendedor = "GTCMARCOS",
                Pin = "77777     ",
                Nombre = "Marcos Antonio Gutierrez"
            };

            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorCodVendedorAsync("GTCMARCOS", It.IsAny<CancellationToken>()))
                .ReturnsAsync(usuario);

            var request = new LoginRequest { Usuario = "GTCMARCOS", Pin = "77777" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(resultado);
            Assert.NotNull(okResult.Value);
        }
    }
}
