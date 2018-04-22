import { Component, OnInit } from '@angular/core';
import { UsuarioService } from './usuario.service';
import { Usuario } from './usuario';
import { Grupo } from './grupo';

@Component({
  selector: 'app-usuario',
  templateUrl: './usuario.component.html',
  styleUrls: ['./usuario.component.scss']
})
export class UsuarioComponent implements OnInit {
  usuarios: Usuario[];
  usuario: Usuario;
  grupos: Grupo[];
  constructor(private usuarioSrv: UsuarioService) {
      this.usuarioSrv.getUsuario()
      .then((d: Usuario[])=>{
        this.usuarios = d;
      })
      this.usuarioSrv.getCodigoGrupo()
      .then((a: Grupo[])=>{
        this.grupos = a;
      })
   }

  ngOnInit() {
  }

  seleccionar(usuario){
    this.usuario = usuario;
  }

}
