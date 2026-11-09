namespace Sagrisa.Application.DTOs.Productos
{
    public class ProductoDto
    {
        public Guid Id { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Sku => Codigo;
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public string Familia { get; set; } = "General";
        public string? Division { get; set; }
        public string Presentacion { get; set; } = "Unidad";
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public string Bodega { get; set; } = "Bodega Central";
        public bool Activo { get; set; }
    }
}
