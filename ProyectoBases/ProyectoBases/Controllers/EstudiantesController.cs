using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProyectoBases.Models;

namespace ProyectoBases.Controllers
{
    [Produces("application/json")]
    [Route("api/Estudiantes")]
    public class EstudiantesController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public EstudiantesController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Estudiantes
        [HttpGet]
        public IEnumerable<Estudiante> GetEstudiante()
        {
            return _context.Estudiante;
        }

        // GET: api/Estudiantes/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetEstudiante([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var estudiante = await _context.Estudiante.SingleOrDefaultAsync(m => m.Id == id);

            if (estudiante == null)
            {
                return NotFound();
            }

            return Ok(estudiante);
        }

        // PUT: api/Estudiantes/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutEstudiante([FromRoute] int id, [FromBody] Estudiante estudiante)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != estudiante.Id)
            {
                return BadRequest();
            }

            _context.Entry(estudiante).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EstudianteExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Estudiantes
        [HttpPost]
        public async Task<IActionResult> PostEstudiante([FromBody] Estudiante estudiante)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Estudiante.Add(estudiante);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetEstudiante", new { id = estudiante.Id }, estudiante);
        }

        // DELETE: api/Estudiantes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEstudiante([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var estudiante = await _context.Estudiante.SingleOrDefaultAsync(m => m.Id == id);
            if (estudiante == null)
            {
                return NotFound();
            }

            _context.Estudiante.Remove(estudiante);
            await _context.SaveChangesAsync();

            return Ok(estudiante);
        }

        private bool EstudianteExists(int id)
        {
            return _context.Estudiante.Any(e => e.Id == id);
        }
    }
}