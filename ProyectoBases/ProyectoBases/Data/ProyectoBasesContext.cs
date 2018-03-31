using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace ProyectoBases.Models
{
    public class ProyectoBasesContext : DbContext
    {
        public ProyectoBasesContext (DbContextOptions<ProyectoBasesContext> options)
            : base(options)
        {
        }

        public DbSet<ProyectoBases.Models.Profesor> Profesor { get; set; }
    }
}
