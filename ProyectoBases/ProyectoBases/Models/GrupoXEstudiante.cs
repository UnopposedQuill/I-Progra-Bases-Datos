using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class GrupoXEstudiante
    {
        [Key]
        public int Id { get; set; }
        public float NotaAcumulada { get; set; }
        public bool Habilitado { get; set; }
    }

}
