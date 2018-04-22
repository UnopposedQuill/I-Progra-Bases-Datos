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
    [Route("api/Grupo")]
    public class GrupoController : Controller
    {
        private readonly ProyectoBasesContext _context;

        public GrupoController(ProyectoBasesContext context)
        {
            _context = context;
        }

        // GET: api/Grupo
        [HttpGet]
        public IEnumerable<Grupo> GetGrupo()
        {
            return _context.Grupo;
        }

        // GET: api/Grupo/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetGrupo([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var grupo = await _context.Grupo.SingleOrDefaultAsync(m => m.Id == id);

            if (grupo == null)
            {
                return NotFound();
            }

            return Ok(grupo);
        }

        // PUT: api/Grupo/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutGrupo([FromRoute] int id, [FromBody] Grupo grupo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != grupo.Id)
            {
                return BadRequest();
            }

            _context.Entry(grupo).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!GrupoExists(id))
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

        // POST: api/Grupo
        [HttpPost]
        public async Task<IActionResult> PostGrupo([FromBody] Grupo grupo)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.Grupo.Add(grupo);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetGrupo", new { id = grupo.Id }, grupo);
        }

        // DELETE: api/Grupo/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteGrupo([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var grupo = await _context.Grupo.SingleOrDefaultAsync(m => m.Id == id);
            if (grupo == null)
            {
                return NotFound();
            }

            _context.Grupo.Remove(grupo);
            await _context.SaveChangesAsync();

            return Ok(grupo);
        }

        private bool GrupoExists(int id)
        {
            return _context.Grupo.Any(e => e.Id == id);
        }
    }
}