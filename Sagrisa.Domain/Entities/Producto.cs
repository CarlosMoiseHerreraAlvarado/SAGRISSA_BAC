namespace Sagrisa.Domain.Entities
{
    // Representa un producto del catalogo de SAGRISA.
    // Cada producto tiene un codigo unico, nombre, presentacion, precio y bodega de origen.
    // El campo Activo indica si el producto esta disponible para venta o no.
    public class Producto
    {
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Presentacion { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public string Bodega { get; set; } = string.Empty;
        public bool Activo { get; set; }
    }
}
