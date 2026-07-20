using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sagrisa.Application.DTOs.Usuarios
{
    public class UsuarioDTO
    {
        public string Pin { get; set; }
        public string Nombre { get; set; }
        public string Division { get; set; }
        public string Pais { get; set; }
        public string CodVendedor { get; set; }
        public string Cargo { get; set; }
        public string email { get; set; }
        public string Cambiado { get; set; }
        public string Dui { get; set; }
        public string DocPersonal { get; set; }
        public string Token { get; set; }
        public DateTime? FechaSesion { get; set; }
        public string GerenciadoPor { get; set; }
        public string SupervisadoPor { get; set; }
        public string Rol { get; set; }
    }
}
