using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sagrisa.Domain.Common;

namespace Sagrisa.API.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    public class TestController : SagrisaBaseController
    {
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status200OK)]
        public IActionResult GetStatus()
        {
            var statusInfo = new
            {
                Status = "Online",
                Timestamp = DateTime.UtcNow,
                Environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production",
                Version = "1.2.0",
                Platform = ".NET 8 LTS - Clean Architecture",
                Integration = "SAGRISA PWA + Supabase + Dynamics ERP"
            };

            return Ok(ApiResponse<object>.Ok(statusInfo, "API SAGRISA funcionando correctamente"));
        }
    }
}
