using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sagrisa.Application.DTOs.Pedidos
{
    public class PedidoEncabezadoDto
    {
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; }
        public string CodVendedor { get; set; }
        public string Tpago { get; set; }
        public string FechaPedido { get; set; }
        public string FechaEntrega { get; set; }
        public int PlazoEntregaPedido { get; set; }
        public string Observacion { get; set; }
        public decimal TotalPedido { get; set; }
        public string Pais { get; set; }
        public int IdDireccion { get; set; }
        public string EstCorr { get; set; }
        public DateTime FechHoraInsert { get; set; }
        public string Origen { get; set; }
        public string idBac { get; set; }
        public string idClieCaf { get; set; }
        public string EstadoBac { get; set; }
        public string orderCaf { get; set; }
        public string estatus { get; set; }
        public string NumFactura { get; set; }
        public string ErrCorreo { get; set; }
    }
}
