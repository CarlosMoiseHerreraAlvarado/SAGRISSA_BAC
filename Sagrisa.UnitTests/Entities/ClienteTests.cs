using Sagrisa.Domain.Entities;

namespace Sagrisa.UnitTests.Entities
{
    public class ClienteTests
    {
        [Fact]
        public void EstaInactivo_Activo_DevuelveFalse()
        {
            var cliente = new Cliente { INACTIVE = 0 };
            Assert.False(cliente.EstaInactivo);
        }

        [Fact]
        public void EstaInactivo_Inactivo_DevuelveTrue()
        {
            var cliente = new Cliente { INACTIVE = 1 };
            Assert.True(cliente.EstaInactivo);
        }

        [Fact]
        public void EstaBloqueado_NoBloqueado_DevuelveFalse()
        {
            var cliente = new Cliente { HOLD = 0 };
            Assert.False(cliente.EstaBloqueado);
        }

        [Fact]
        public void EstaBloqueado_Bloqueado_DevuelveTrue()
        {
            var cliente = new Cliente { HOLD = 1 };
            Assert.True(cliente.EstaBloqueado);
        }

        [Theory]
        [InlineData(2)]
        [InlineData(255)]
        public void INACTIVE_ValoresNoEstandar_NoEsActivoNiInactivo(int valor)
        {
            var cliente = new Cliente { INACTIVE = valor };
            Assert.False(cliente.EstaInactivo);
        }
    }
}
