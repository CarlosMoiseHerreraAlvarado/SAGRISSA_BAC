namespace Sagrisa.Domain.Entities;

public sealed class MetaComercial
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string PeriodoTipo { get; set; } = "mensual";
    public DateTime PeriodoInicio { get; set; }
    public DateTime PeriodoFin { get; set; }
    public string? DivisionCodigo { get; set; }
    public string? VendedorCodigo { get; set; }
    public decimal Proyeccion { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
