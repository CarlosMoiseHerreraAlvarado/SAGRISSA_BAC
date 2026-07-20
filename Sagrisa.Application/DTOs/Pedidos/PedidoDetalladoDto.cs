using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sagrisa.Application.DTOs.Pedidos
{
    public class PedidoDetalladoDto
    {
        public string NumPedido { get; set; } = string.Empty;
        public string CodCliente { get; set; }
        public string CodProducto { get; set; }
        public string NomProducto { get; set; }
        public string Presentacion { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PrecioTotal { get; set; }
        public string CodVendedor { get; set; }
        public string Bodega { get; set; }
        public string Origen { get; set; }
    }
}
