using Microsoft.AspNetCore.Mvc;

namespace Sagrisa.API.Controllers
{
    // Controlador de prueba que verifica que la API este funcionando.
    // Responde en GET /api/test con un mensaje indicando que todo esta bien.
    public class TestController : SagrisaBaseController
    {
        [HttpGet("test")]
        public IActionResult GetTest()
        {
            return Ok(new
            {
                Success = true,
                Message = "API SAGRISA funcionando correctamente"
            });
        }
    }
}
