using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ProyectoBases.Models
{
    public class EvaluacionXEstudiante
    {
        [Key]
        public int Id { get; set; }
        public float Nota { get; set; }
        public bool Habilitado { get; set; }
    }
}
