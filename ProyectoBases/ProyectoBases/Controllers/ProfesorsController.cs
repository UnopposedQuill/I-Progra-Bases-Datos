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
    [Route("api/usuarios")]
    public class ProfesorsController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public ProfesorsController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Profesors
        [HttpGet]
        public IEnumerable<Profesor> GetProfesor()
        {
            return _context.Profesor;
        }

        // GET: api/Profesors/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetProfesor([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var profesor = await _context.Profesor.SingleOrDefaultAsync(m => m.Id == id);

            if (profesor == null)
            {
                return NotFound();
            }

            return Ok(profesor);
        }

        // PUT: api/Profesors/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProfesor([FromRoute] int id, [FromBody] Profesor profesor)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != profesor.Id)
            {
                return BadRequest();
            }

            _context.Entry(profesor).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProfesorExists(id))
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

        // POST: api/Profesors
        [HttpPost]
        public async Task<IActionResult> PostProfesor([FromBody] Profesor profesor)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Profesor.Add(profesor);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProfesor", new { id = profesor.Id }, profesor);
        }

        // DELETE: api/Profesors/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProfesor([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var profesor = await _context.Profesor.SingleOrDefaultAsync(m => m.Id == id);
            if (profesor == null)
            {
                return NotFound();
            }

            _context.Profesor.Remove(profesor);
            await _context.SaveChangesAsync();

            return Ok(profesor);
        }

        private bool ProfesorExists(int id)
        {
            return _context.Profesor.Any(e => e.Id == id);
        }
    }
}