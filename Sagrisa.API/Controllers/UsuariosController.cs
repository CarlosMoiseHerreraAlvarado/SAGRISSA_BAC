using Microsoft.AspNetCore.Mvc;
using Sagrisa.Application.DTOs.Usuarios;
using Sagrisa.Application.Interfaces.Repositories;

namespace Sagrisa.API.Controllers
{
    // Controlador que maneja las peticiones relacionadas con usuarios.
    // Ruta base: /api/usuarios
    // Por ahora solo devuelve la lista de usuarios mock.
    [Route("usuarios")]
    public class UsuariosController : SagrisaBaseController
    {
        private readonly IUsuarioRepository _usuarioRepository;

        // El repositorio se inyecta aqui para que el controlador pueda acceder a los datos.
        // En este momento usa datos mock, despues se conectara a SQL Server.
        public UsuariosController(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }

        // GET /api/usuarios
        // Devuelve la lista completa de todos los usuarios registrados.
        [HttpGet]
        public async Task<IActionResult> ObtenerTodos(CancellationToken cancellationToken)
        {
            var usuarios = await _usuarioRepository.ObtenerTodosAsync(cancellationToken);

            // Convierte las entidades de dominio a DTOs para enviar al frontend.
            // El DTO es el contrato que el frontend consume, la entidad es interna del backend.
            var resultado = usuarios.Select(u => new UsuarioDTO
            {
                Pin = u.Pin.Trim(),
                Nombre = u.Nombre,
                Division = u.Division,
                Pais = u.Pais,
                CodVendedor = u.CodVendedor,
                Cargo = u.Cargo,
                email = u.Email,
                Cambiado = u.Cambiado,
                Dui = u.Dui,
                DocPersonal = u.DocPersonal,
                Token = u.Token,
                FechaSesion = u.FechaSesion,
                GerenciadoPor = u.GerenciadoPor,
                SupervisadoPor = u.SupervisadoPor,
                Rol = u.Rol
            }).ToList();

            return Ok(resultado);
        }
    }
}
