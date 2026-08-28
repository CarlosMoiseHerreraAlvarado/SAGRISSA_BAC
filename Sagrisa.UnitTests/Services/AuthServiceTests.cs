using Moq;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Security;
using Sagrisa.Application.Services;
using Sagrisa.Domain.Entities;

namespace Sagrisa.UnitTests.Services
{
    public class AuthServiceTests
    {
        private readonly Mock<IUsuarioRepository> _usuarioRepositoryMock;
        private readonly Mock<IPasswordHasher> _passwordHasherMock;
        private readonly Mock<IJwtTokenGenerator> _jwtTokenGeneratorMock;
        private readonly AuthService _authService;

        public AuthServiceTests()
        {
            _usuarioRepositoryMock = new Mock<IUsuarioRepository>();
            _passwordHasherMock = new Mock<IPasswordHasher>();
            _jwtTokenGeneratorMock = new Mock<IJwtTokenGenerator>();

            _authService = new AuthService(
                _usuarioRepositoryMock.Object,
                _passwordHasherMock.Object,
                _jwtTokenGeneratorMock.Object);
        }

        [Fact]
        public async Task LoginAsync_UsuarioExistenteConHashValido_RetornaOkConToken()
        {
            // Arrange
            var usuario = new Usuario
            {
                Id = Guid.NewGuid(),
                Dui = "00123456-7",
                PinHash = "$2a$11$mockedhash",
                Nombre = "Marcos Gutierrez",
                CodVendedor = "GTCMARCOS",
                Rol = "Vendedor",
                IsActive = true
            };

            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorDuiAsync("00123456-7", It.IsAny<CancellationToken>()))
                .ReturnsAsync(usuario);

            _passwordHasherMock
                .Setup(p => p.VerifyPassword("77777", "$2a$11$mockedhash"))
                .Returns(true);

            int outSeconds = 86400;
            _jwtTokenGeneratorMock
                .Setup(j => j.GenerateToken(usuario, out outSeconds))
                .Returns("GENERATED_JWT_TOKEN");

            var request = new LoginRequest { Dui = "00123456-7", Pin = "77777" };

            // Act
            var result = await _authService.LoginAsync(request, CancellationToken.None);

            // Assert
            Assert.True(result.Success);
            Assert.NotNull(result.Data);
            Assert.Equal("GENERATED_JWT_TOKEN", result.Data.Token);
            Assert.Equal("Marcos Gutierrez", result.Data.User.Nombre);
        }

        [Fact]
        public async Task LoginAsync_PinInvalido_RetornaFail()
        {
            // Arrange
            var usuario = new Usuario
            {
                Id = Guid.NewGuid(),
                Dui = "00123456-7",
                PinHash = "$2a$11$mockedhash",
                IsActive = true
            };

            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorDuiAsync("00123456-7", It.IsAny<CancellationToken>()))
                .ReturnsAsync(usuario);

            _passwordHasherMock
                .Setup(p => p.VerifyPassword("00000", "$2a$11$mockedhash"))
                .Returns(false);

            var request = new LoginRequest { Dui = "00123456-7", Pin = "00000" };

            // Act
            var result = await _authService.LoginAsync(request, CancellationToken.None);

            // Assert
            Assert.False(result.Success);
            Assert.Contains("incorrectos", result.Message, StringComparison.OrdinalIgnoreCase);
        }

        [Fact]
        public async Task LoginAsync_UsuarioNoExiste_RetornaFail()
        {
            // Arrange
            _usuarioRepositoryMock
                .Setup(r => r.ObtenerPorDuiAsync("99999999-9", It.IsAny<CancellationToken>()))
                .ReturnsAsync((Usuario?)null);

            var request = new LoginRequest { Dui = "99999999-9", Pin = "12345" };

            // Act
            var result = await _authService.LoginAsync(request, CancellationToken.None);

            // Assert
            Assert.False(result.Success);
        }
    }
}
