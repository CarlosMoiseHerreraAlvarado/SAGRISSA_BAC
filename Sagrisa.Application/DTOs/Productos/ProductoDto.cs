namespace Sagrisa.Application.DTOs.Productos
{
    // Objeto de transferencia que representa un producto para el frontend.
    // Contiene solo los datos que el frontend necesita mostrar,
    // no toda la informacion interna de la entidad de dominio.
    public class ProductoDto
    {
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Presentacion { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public string Bodega { get; set; } = string.Empty;
        public bool Activo { get; set; }
    }
}
