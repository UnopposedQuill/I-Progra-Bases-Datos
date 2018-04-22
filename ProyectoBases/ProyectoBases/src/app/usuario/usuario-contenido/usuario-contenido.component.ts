import { Component, OnInit, Input, OnChanges } from '@angular/core';
import { Usuario } from '../usuario';
import { FormGroup, FormBuilder, Validators } from '@angular/forms'; 

@Component({
  selector: 'app-usuario-contenido',
  templateUrl: './usuario-contenido.component.html',
  styleUrls: ['./usuario-contenido.component.scss']
})
export class UsuarioContenidoComponent implements OnInit, OnChanges {
  @Input() usuario: Usuario;
  frmUsuario: FormGroup;
  constructor(private fb: FormBuilder) {
    this.frmUsuario = this.fb.group({
      nombre:['',Validators.required],
      email:['',Validators.email],
      carnet:['',Validators.required],
    })
   }

  ngOnInit() {
  }

  ngOnChanges(){
    if (this.usuario === undefined) return;
    this.frmUsuario.setValue({
      nombre: this.usuario.nombre,
      email: this.usuario.email,
      carnet: this.usuario.carnet
    })
  }

}
