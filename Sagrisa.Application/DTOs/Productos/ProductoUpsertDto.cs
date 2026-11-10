namespace Sagrisa.Application.DTOs.Productos;

public sealed class ProductoUpsertDto
{
    public string Codigo { get; set; } = string.Empty;
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public string Familia { get; set; } = "General";
    public string? Division { get; set; }
    public string? Clase { get; set; }
    public string? FechaVencimiento { get; set; }
    public string? Lote { get; set; }
    public string Presentacion { get; set; } = "Unidad";
    public decimal Precio { get; set; }
    public int Stock { get; set; }
    public string Bodega { get; set; } = "Bodega Central";
    public bool Activo { get; set; } = true;
}
