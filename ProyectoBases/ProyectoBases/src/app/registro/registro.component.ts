import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Usuario } from '../usuario/usuario';
import { UsuarioService } from '../usuario/usuario.service';

@Component({
  selector: 'app-registro',
  templateUrl: './registro.component.html',
  styles: []
})
export class RegistroComponent implements OnInit {
  frmRegistro: FormGroup; 
  constructor(private fb: FormBuilder,
    private usuarioSrv: UsuarioService) {
    this.frmRegistro = this.fb.group({
      nombre: ['',Validators.required],
      email: ['',Validators.email],
      contraseña: ['',Validators.required],
      confirmar: ['',Validators.required],

    })
   }

  ngOnInit() {
  }

  validacion(){
    const frm = this.frmRegistro.value;
    if (frm.confirmar==frm.contraseña)
      return true;
    else 
      return false;
    
  }

  registro(){
    const frm = this.frmRegistro.value;
    let usuario = new Usuario();
    usuario.Email = frm.email;
    usuario.Nombre = frm.nombre;
    usuario.contraseña = frm.contraseña;

    this.usuarioSrv.grabar(usuario).then();
  }

}
