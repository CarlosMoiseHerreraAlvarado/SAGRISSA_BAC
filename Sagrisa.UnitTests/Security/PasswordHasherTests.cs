using Sagrisa.Infrastructure.Security;

namespace Sagrisa.UnitTests.Security
{
    public class PasswordHasherTests
    {
        private readonly PasswordHasher _hasher = new();

        [Fact]
        public void HashPassword_GeneraHashBCryptValido()
        {
            var pin = "12345";
            var hash = _hasher.HashPassword(pin);

            Assert.NotEmpty(hash);
            Assert.StartsWith("$2a$", hash);
        }

        [Fact]
        public void VerifyPassword_PinCorrecto_DevuelveTrue()
        {
            var pin = "77777";
            var hash = _hasher.HashPassword(pin);

            var resultado = _hasher.VerifyPassword(pin, hash);
            Assert.True(resultado);
        }

        [Fact]
        public void VerifyPassword_PinIncorrecto_DevuelveFalse()
        {
            var pin = "77777";
            var hash = _hasher.HashPassword(pin);

            var resultado = _hasher.VerifyPassword("00000", hash);
            Assert.False(resultado);
        }
    }
}
