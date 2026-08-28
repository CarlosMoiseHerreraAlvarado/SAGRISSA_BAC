namespace Sagrisa.Domain.Entities
{
    public class Producto
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Codigo { get; set; } = string.Empty;
        public string Sku => Codigo;
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public string Familia { get; set; } = "General";
        public string Presentacion { get; set; } = "Unidad";
        public decimal Precio { get; set; }
        public int Stock { get; set; } = 0;
        public string Bodega { get; set; } = "Bodega Central";
        public bool Activo { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
