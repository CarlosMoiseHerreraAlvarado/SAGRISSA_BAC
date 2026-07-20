using Microsoft.AspNetCore.Mvc;

namespace Sagrisa.API.Controllers
{
    // Controlador base del que heredan todos los demas controladores.
    // Define la ruta base "api" y marca esta clase como un controlador de API.
    // Todos los endpoints empezaran con /api/ seguido de la ruta de cada controlador.
    [ApiController]
    [Route("api")]
    public class SagrisaBaseController : ControllerBase { }
}
