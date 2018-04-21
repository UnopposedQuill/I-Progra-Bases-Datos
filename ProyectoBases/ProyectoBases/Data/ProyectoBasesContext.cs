using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using ProyectoBases.Models;

namespace ProyectoBases.Models
{
    public class ProyectoBasesContext : DbContext
    {
        public ProyectoBasesContext (DbContextOptions<ProyectoBasesContext> options)
            : base(options)
        {
        }

        public DbSet<ProyectoBases.Models.Profesor> Profesor { get; set; }

        public DbSet<ProyectoBases.Models.Estudiante> Estudiante { get; set; }
    }
}
