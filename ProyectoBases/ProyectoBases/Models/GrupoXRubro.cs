using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class GrupoXRubro
    {
        [Key]
        public int Id { get; set; }
        public float ValorPorcentual { get; set; }
        public bool EsFijo { get; set; }
        public int Contador { get; set; }
        public bool Habilitado { get; set; }

    }
}
