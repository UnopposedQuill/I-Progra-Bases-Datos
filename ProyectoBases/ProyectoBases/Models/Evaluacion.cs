using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class Evaluacion
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public DateTime Fecha { get; set; }
        public float ValorPorcentual { get; set; }
        public string Descripcion { get; set; }
        public bool Habilitado { get; set; }
    }
}
