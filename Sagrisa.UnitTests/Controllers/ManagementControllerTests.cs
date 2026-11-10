using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Sagrisa.API.Controllers;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Domain.Entities;
using Sagrisa.Domain.Enums;

namespace Sagrisa.UnitTests.Controllers;

public sealed class ManagementControllerTests
{
    [Fact]
    public async Task ApprovalDecision_SupervisorDeOtroEquipo_NoActualizaPedido()
    {
        var targetOrder = new Pedido
        {
            Id = Guid.NewGuid(),
            NumPedido = "ORD-OTHER",
            CodVendedor = "SELLER-OTHER",
            Estatus = "Pendiente"
        };
        var pedidos = new Mock<IPedidoRepository>();
        pedidos.Setup(x => x.ObtenerPorNumeroAsync(targetOrder.NumPedido, It.IsAny<CancellationToken>()))
            .ReturnsAsync(targetOrder);
        pedidos.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([targetOrder]);

        var usuarios = new Mock<IUsuarioRepository>();
        usuarios.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([new Usuario
            {
                Dui = "90000002-2",
                CodVendedor = targetOrder.CodVendedor,
                SupervisadoPor = "90000003-3"
            }]);

        var controller = new ManagementController(
            pedidos.Object,
            usuarios.Object,
            Mock.Of<IClienteRepository>(),
            Mock.Of<IFacturaRepository>(),
            Mock.Of<ICobroRepository>(),
            Mock.Of<IAprobacionRepository>(),
            Mock.Of<IAuditEventRepository>(),
            Mock.Of<IMetaRepository>());
        controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new ClaimsPrincipal(new ClaimsIdentity(
                [
                    new Claim("dui", "90000001-1"),
                    new Claim(ClaimTypes.Role, "Supervisor")
                ], "test"))
            }
        };

        var result = await controller.ApprovalDecision(
            targetOrder.NumPedido,
            new ApprovalDecisionRequest { Decision = "approve" },
            CancellationToken.None);

        Assert.IsType<ForbidResult>(result);
        pedidos.Verify(
            x => x.ActualizarEstadoAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string?>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task Analytics_GerenteAgricola_FiltraPorAreaAgricola()
    {
        var orderAgricola = new Pedido
        {
            Id = Guid.NewGuid(),
            NumPedido = "ORD-AGR",
            CodVendedor = "VEND-AGR",
            FechaPedido = DateTime.UtcNow,
            TotalPedido = 500m,
            Status = OrderStatus.Approved,
            Estatus = "Aprobado",
            Pais = "SV",
            Detalles = []
        };
        var orderVeterinaria = new Pedido
        {
            Id = Guid.NewGuid(),
            NumPedido = "ORD-VET",
            CodVendedor = "VEND-VET",
            FechaPedido = DateTime.UtcNow,
            TotalPedido = 1200m,
            Status = OrderStatus.Approved,
            Estatus = "Aprobado",
            Pais = "SV",
            Detalles = []
        };

        var pedidos = new Mock<IPedidoRepository>();
        pedidos.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([orderAgricola, orderVeterinaria]);

        var usuarios = new Mock<IUsuarioRepository>();
        usuarios.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([
                new Usuario { CodVendedor = "VEND-AGR", Division = "AGRICOLA", Nombre = "Vendedor Agrícola" },
                new Usuario { CodVendedor = "VEND-VET", Division = "VETERINARIA", Nombre = "Vendedor Veterinaria" }
            ]);

        var facturas = new Mock<IFacturaRepository>();
        facturas.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([]);

        var cobros = new Mock<ICobroRepository>();
        cobros.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([]);

        var controller = new ManagementController(
            pedidos.Object,
            usuarios.Object,
            Mock.Of<IClienteRepository>(),
            facturas.Object,
            cobros.Object,
            Mock.Of<IAprobacionRepository>(),
            Mock.Of<IAuditEventRepository>(),
            Mock.Of<IMetaRepository>());

        // Gerente con Claim de Division "AGRICOLA"
        controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new ClaimsPrincipal(new ClaimsIdentity(
                [
                    new Claim("dui", "12345678-9"),
                    new Claim(ClaimTypes.Role, "Gerente"),
                    new Claim("division", "AGRICOLA")
                ], "test"))
            }
        };

        var result = await controller.Analytics(null, CancellationToken.None);
        var okResult = Assert.IsType<OkObjectResult>(result);

        var json = JsonSerializer.Serialize(okResult.Value);
        using var doc = JsonDocument.Parse(json);
        var root = doc.RootElement;

        Assert.True(root.GetProperty("success").GetBoolean());
        var data = root.GetProperty("data");
        Assert.Equal(500m, data.GetProperty("totalRevenue").GetDecimal());
        Assert.Equal(1, data.GetProperty("totalOrders").GetInt32());
    }

    [Fact]
    public async Task Team_BusquedaPorVendedor_FiltraPorNombreOCodigo()
    {
        var usuarios = new Mock<IUsuarioRepository>();
        usuarios.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([
                new Usuario { Id = Guid.NewGuid(), CodVendedor = "SVWLOBO", Nombre = "Walter Wilfredo Lobo", Division = "VETERINARIA" },
                new Usuario { Id = Guid.NewGuid(), CodVendedor = "SVJPEREZ", Nombre = "Juan Perez", Division = "AGRICOLA" }
            ]);

        var pedidos = new Mock<IPedidoRepository>();
        pedidos.Setup(x => x.ObtenerTodosAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync([]);

        var controller = new ManagementController(
            pedidos.Object,
            usuarios.Object,
            Mock.Of<IClienteRepository>(),
            Mock.Of<IFacturaRepository>(),
            Mock.Of<ICobroRepository>(),
            Mock.Of<IAprobacionRepository>(),
            Mock.Of<IAuditEventRepository>(),
            Mock.Of<IMetaRepository>());

        controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new ClaimsPrincipal(new ClaimsIdentity(
                [
                    new Claim("dui", "12345678-9"),
                    new Claim(ClaimTypes.Role, "Admin")
                ], "test"))
            }
        };

        var result = await controller.Team("lobo", null, CancellationToken.None);
        var okResult = Assert.IsType<OkObjectResult>(result);

        var json = JsonSerializer.Serialize(okResult.Value);
        using var doc = JsonDocument.Parse(json);
        var root = doc.RootElement;

        Assert.True(root.GetProperty("success").GetBoolean());
        Assert.Equal(1, root.GetProperty("data").GetArrayLength());
    }

    [Fact]
    public async Task Analytics_Director_RetornaMetricasDirector()
    {
        var controller = new ManagementController(
            Mock.Of<IPedidoRepository>(),
            Mock.Of<IUsuarioRepository>(),
            Mock.Of<IClienteRepository>(),
            Mock.Of<IFacturaRepository>(),
            Mock.Of<ICobroRepository>(),
            Mock.Of<IAprobacionRepository>(),
            Mock.Of<IAuditEventRepository>(),
            Mock.Of<IMetaRepository>());

        controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new ClaimsPrincipal(new ClaimsIdentity(
                [
                    new Claim("dui", "11111111-1"),
                    new Claim(ClaimTypes.Role, "Director")
                ], "test"))
            }
        };

        var result = await controller.Analytics(null, CancellationToken.None);
        var okResult = Assert.IsType<OkObjectResult>(result);

        var json = JsonSerializer.Serialize(okResult.Value);
        using var doc = JsonDocument.Parse(json);
        var root = doc.RootElement;

        Assert.True(root.GetProperty("success").GetBoolean());
        var data = root.GetProperty("data");
        Assert.True(data.TryGetProperty("regionalCollections", out var regCol));
        Assert.True(data.TryGetProperty("topClients", out var topCli));
        Assert.True(data.TryGetProperty("articleClasses", out var artCls));
        Assert.True(data.TryGetProperty("budgetByCountry", out var budCou));
        Assert.True(data.TryGetProperty("budgetByArea", out var budArea));

        Assert.Equal(2, regCol.GetArrayLength());
        Assert.Equal(8, topCli.GetArrayLength());
        Assert.Equal(5, artCls.GetArrayLength());
    }
}
