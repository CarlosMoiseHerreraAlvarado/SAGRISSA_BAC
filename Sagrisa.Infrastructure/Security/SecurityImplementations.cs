using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Sagrisa.Application.Interfaces.Security;
using Sagrisa.Domain.Entities;
using Sagrisa.Infrastructure.Configuration;

namespace Sagrisa.Infrastructure.Security
{
    public class PasswordHasher : IPasswordHasher
    {
        public string HashPassword(string password)
        {
            if (string.IsNullOrWhiteSpace(password)) return string.Empty;
            return BCrypt.Net.BCrypt.HashPassword(password, workFactor: 11);
        }

        public bool VerifyPassword(string password, string hashedPassword)
        {
            if (string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(hashedPassword))
                return false;

            try
            {
                return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
            }
            catch
            {
                return false;
            }
        }
    }

    public class JwtTokenGenerator : IJwtTokenGenerator
    {
        private readonly JwtSettings _jwtSettings;

        public JwtTokenGenerator(IOptions<JwtSettings> jwtOptions)
        {
            _jwtSettings = jwtOptions.Value;
        }

        public string GenerateToken(Usuario usuario, out int expiresInSeconds)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_jwtSettings.SecretKey);

            var claims = new List<Claim>
            {
                new(JwtRegisteredClaimNames.Sub, usuario.Id.ToString()),
                new(JwtRegisteredClaimNames.UniqueName, usuario.Dui),
                new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new("dui", usuario.Dui),
                new("name", usuario.Nombre),
                new("role", usuario.Rol),
                new(ClaimTypes.Role, usuario.Rol),
                new("codVendedor", usuario.CodVendedor ?? string.Empty),
                new("email", usuario.Email ?? string.Empty)
            };

            var expiration = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpirationMinutes);
            expiresInSeconds = (int)(expiration - DateTime.UtcNow).TotalSeconds;

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = expiration,
                Issuer = _jwtSettings.Issuer,
                Audience = _jwtSettings.Audience,
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}
