import { Component, OnInit } from '@angular/core';
import { UsuarioService } from './usuario.service';
import { Usuario } from './usuario';

@Component({
  selector: 'app-usuario',
  templateUrl: './usuario.component.html',
  styleUrls: ['./usuario.component.scss']
})
export class UsuarioComponent implements OnInit {
  usuarios: Usuario[];
  usuario: Usuario;
  constructor(private usuarioSrv: UsuarioService) {
      this.usuarioSrv.getUsuario()
      .then((d: Usuario[])=>{
        this.usuarios = d;

      })
   }

  ngOnInit() {
  }

  seleccionar(usuario){
    this.usuario = usuario;
  }

}
