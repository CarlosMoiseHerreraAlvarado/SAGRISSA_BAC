using Sagrisa.Application.DTOs.Auth;
using Sagrisa.Application.Interfaces.Repositories;
using Sagrisa.Application.Interfaces.Security;
using Sagrisa.Application.Interfaces.Services;
using Sagrisa.Domain.Common;

namespace Sagrisa.Application.Services
{
    public class AuthService : IAuthService
    {
        private readonly IUsuarioRepository _usuarioRepository;
        private readonly IPasswordHasher _passwordHasher;
        private readonly IJwtTokenGenerator _jwtTokenGenerator;

        public AuthService(
            IUsuarioRepository usuarioRepository,
            IPasswordHasher passwordHasher,
            IJwtTokenGenerator jwtTokenGenerator)
        {
            _usuarioRepository = usuarioRepository;
            _passwordHasher = passwordHasher;
            _jwtTokenGenerator = jwtTokenGenerator;
        }

        public async Task<ApiResponse<LoginResponse>> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(request.Dui) || string.IsNullOrWhiteSpace(request.Pin))
            {
                return ApiResponse<LoginResponse>.Fail("El DUI y el PIN son obligatorios.");
            }

            var cleanDui = request.Dui.Trim();
            var cleanPin = request.Pin.Trim();

            var usuario = await _usuarioRepository.ObtenerPorDuiAsync(cleanDui, cancellationToken);
            if (usuario is null || !usuario.IsActive)
            {
                return ApiResponse<LoginResponse>.Fail("DUI o PIN incorrectos.");
            }

            // Verificacion segura de PIN (soporta hash BCrypt y migracion fluida de mock/legacy)
            bool pinValido = false;
            if (!string.IsNullOrEmpty(usuario.PinHash))
            {
                pinValido = _passwordHasher.VerifyPassword(cleanPin, usuario.PinHash);
            }
            else if (!string.IsNullOrEmpty(usuario.Pin))
            {
                var legacyPin = usuario.Pin.Trim();
                pinValido = string.Equals(legacyPin, cleanPin, StringComparison.Ordinal);

                // Migracion automatica al primer login a hash BCrypt
                if (pinValido)
                {
                    usuario.PinHash = _passwordHasher.HashPassword(cleanPin);
                    await _usuarioRepository.ActualizarPinAsync(usuario.Id, usuario.PinHash, cancellationToken);
                }
            }

            if (!pinValido)
            {
                return ApiResponse<LoginResponse>.Fail("DUI o PIN incorrectos.");
            }

            // Generacion de JWT oficial con claims
            var token = _jwtTokenGenerator.GenerateToken(usuario, out int expiresIn);

            var userProfile = new UserProfileDto
            {
                Id = usuario.Id,
                Dui = usuario.Dui,
                Nombre = usuario.Nombre,
                Division = usuario.Division,
                Pais = usuario.Pais,
                CodVendedor = usuario.CodVendedor,
                Cargo = usuario.Cargo,
                Email = usuario.Email,
                DocPersonal = usuario.DocPersonal,
                Rol = usuario.Rol,
                IsActive = usuario.IsActive,
                IsOfflineCapable = usuario.IsOfflineCapable
            };

            var response = new LoginResponse
            {
                Token = token,
                TokenType = "Bearer",
                ExpiresIn = expiresIn,
                User = userProfile
            };

            return ApiResponse<LoginResponse>.Ok(response, "Inicio de sesión exitoso");
        }

        public async Task<ApiResponse<UserProfileDto>> GetProfileAsync(Guid userId, CancellationToken cancellationToken = default)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(userId, cancellationToken);
            if (usuario is null)
            {
                return ApiResponse<UserProfileDto>.Fail("Usuario no encontrado.");
            }

            return ApiResponse<UserProfileDto>.Ok(new UserProfileDto
            {
                Id = usuario.Id,
                Dui = usuario.Dui,
                Nombre = usuario.Nombre,
                Division = usuario.Division,
                Pais = usuario.Pais,
                CodVendedor = usuario.CodVendedor,
                Cargo = usuario.Cargo,
                Email = usuario.Email,
                DocPersonal = usuario.DocPersonal,
                Rol = usuario.Rol,
                IsActive = usuario.IsActive,
                IsOfflineCapable = usuario.IsOfflineCapable
            });
        }

        public async Task<ApiResponse<UserProfileDto>> GetProfileByDuiAsync(string dui, CancellationToken cancellationToken = default)
        {
            var usuario = await _usuarioRepository.ObtenerPorDuiAsync(dui, cancellationToken);
            if (usuario is null)
            {
                return ApiResponse<UserProfileDto>.Fail("Usuario no encontrado.");
            }

            return ApiResponse<UserProfileDto>.Ok(new UserProfileDto
            {
                Id = usuario.Id,
                Dui = usuario.Dui,
                Nombre = usuario.Nombre,
                Division = usuario.Division,
                Pais = usuario.Pais,
                CodVendedor = usuario.CodVendedor,
                Cargo = usuario.Cargo,
                Email = usuario.Email,
                DocPersonal = usuario.DocPersonal,
                Rol = usuario.Rol,
                IsActive = usuario.IsActive,
                IsOfflineCapable = usuario.IsOfflineCapable
            });
        }

        public async Task<ApiResponse> ChangePinAsync(Guid userId, ChangePinRequest request, CancellationToken cancellationToken = default)
        {
            var usuario = await _usuarioRepository.ObtenerPorIdAsync(userId, cancellationToken);
            if (usuario is null)
            {
                return ApiResponse.Fail("Usuario no encontrado.");
            }

            bool pinActualValido = false;
            if (!string.IsNullOrEmpty(usuario.PinHash))
            {
                pinActualValido = _passwordHasher.VerifyPassword(request.PinActual.Trim(), usuario.PinHash);
            }
            else if (!string.IsNullOrEmpty(usuario.Pin))
            {
                pinActualValido = string.Equals(usuario.Pin.Trim(), request.PinActual.Trim(), StringComparison.Ordinal);
            }

            if (!pinActualValido)
            {
                return ApiResponse.Fail("El PIN actual es incorrecto.");
            }

            var nuevoHash = _passwordHasher.HashPassword(request.NuevoPin.Trim());
            await _usuarioRepository.ActualizarPinAsync(usuario.Id, nuevoHash, cancellationToken);

            return ApiResponse.Ok("PIN actualizado exitosamente.");
        }
    }
}
