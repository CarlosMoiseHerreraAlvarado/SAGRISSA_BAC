using Microsoft.AspNetCore.Mvc;
using Moq;
using Sagrisa.API.Controllers;
using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.UnitTests.Controllers
{
    public class AuthControllerTests
    {
        private readonly Mock<IAuthService> _authServiceMock;
        private readonly AuthController _controller;

        public AuthControllerTests()
        {
            _authServiceMock = new Mock<IAuthService>();
            _controller = new AuthController(_authServiceMock.Object);
        }

        [Fact]
        public async Task Login_CredencialesValidas_DevuelveOkConToken()
        {
            // Arrange
            var responseDto = new LoginResponse
            {
                Token = "VALID_JWT_TOKEN",
                TokenType = "Bearer",
                ExpiresIn = 86400,
                User = new UserProfileDto
                {
                    Id = Guid.NewGuid(),
                    Dui = "00123456-7",
                    Nombre = "Marcos Antonio Gutierrez",
                    CodVendedor = "GTCMARCOS",
                    Cargo = "Vendedor",
                    Rol = "Vendedor"
                }
            };

            _authServiceMock
                .Setup(s => s.LoginAsync(It.IsAny<LoginRequest>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(ApiResponse<LoginResponse>.Ok(responseDto));

            var request = new LoginRequest { Dui = "00123456-7", Pin = "77777" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(resultado);
            var apiResponse = Assert.IsType<ApiResponse<LoginResponse>>(okResult.Value);
            Assert.True(apiResponse.Success);
            Assert.NotNull(apiResponse.Data);
            Assert.Equal("VALID_JWT_TOKEN", apiResponse.Data.Token);
            Assert.Equal("Marcos Antonio Gutierrez", apiResponse.Data.Nombre);
        }

        [Fact]
        public async Task Login_PinIncorrecto_DevuelveUnauthorized()
        {
            // Arrange
            _authServiceMock
                .Setup(s => s.LoginAsync(It.IsAny<LoginRequest>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(ApiResponse<LoginResponse>.Fail("DUI o PIN incorrectos."));

            var request = new LoginRequest { Dui = "00123456-7", Pin = "00000" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            var unauthorizedResult = Assert.IsType<UnauthorizedObjectResult>(resultado);
            var apiResponse = Assert.IsType<ApiResponse<LoginResponse>>(unauthorizedResult.Value);
            Assert.False(apiResponse.Success);
        }

        [Fact]
        public async Task Login_ModeloInvalido_DevuelveBadRequest()
        {
            // Arrange
            _controller.ModelState.AddModelError("Dui", "El DUI es obligatorio.");

            var request = new LoginRequest { Dui = "", Pin = "" };

            // Act
            var resultado = await _controller.Login(request, CancellationToken.None);

            // Assert
            Assert.IsType<BadRequestObjectResult>(resultado);
        }
    }
}
