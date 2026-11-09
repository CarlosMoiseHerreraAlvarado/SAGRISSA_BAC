using Microsoft.AspNetCore.Mvc;

namespace Sagrisa.API.Controllers;

/// <summary>
/// Los webhooks del proveedor anterior están fuera del flujo operativo.
/// El intercambio con el legado se implementará mediante ETL controlado.
/// </summary>
[ApiController]
[Route("api/webhooks")]
public sealed class WebhooksController : ControllerBase
{
    [HttpPost("{**route}")]
    public IActionResult LegacyWebhook() => StatusCode(StatusCodes.Status410Gone, new
    {
        success = false,
        message = "Los webhooks del proveedor anterior no están habilitados. Use el proceso de sincronización controlado."
    });
}
