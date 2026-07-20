using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sagrisa.Application.DTOs.Clientes
{
    public class ClienteDto
    {
        public string CodCliente { get; set; }
        public string NomCliente { get; set; }
        public string Clase { get; set; }
        public string Vendedor { get; set; }
        public string Ciudad { get; set; }
        public string TPago { get; set; }
        public bool INACTIVE { get; set; }
        public bool HOLD { get; set; }
        public string LPrecios { get; set; }
        public decimal MontoCredito { get; set; }
        public decimal TotalDeuda { get; set; }
        public decimal SaldoCredito { get; set; }
        public string Correo { get; set; }
    }
}
