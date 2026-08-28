using Sagrisa.Domain.Entities;

namespace Sagrisa.Application.Interfaces.Security
{
    public interface IPasswordHasher
    {
        string HashPassword(string password);
        bool VerifyPassword(string password, string hashedPassword);
    }

    public interface IJwtTokenGenerator
    {
        string GenerateToken(Usuario usuario, out int expiresInSeconds);
    }
}
