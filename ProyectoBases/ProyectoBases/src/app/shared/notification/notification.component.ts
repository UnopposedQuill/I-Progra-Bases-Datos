import { Component, OnInit } from '@angular/core';
import { NotificationService } from './notification.service';

@Component({
  selector: 'app-notification',
  templateUrl: './notification.component.html',
  styles: [`
    .info{
      color: green;
      background-color: rgba(0,255,0, .2);
    }

    .error{
      color: red;
      background-color: rgba(255,0,0, .2);
    }
  `]
})
export class NotificationComponent implements OnInit {
  mensaje: string = 'Bienvenido'
  tipo: string = 'info'
  constructor(private notificaSrv: NotificationService) { 
  this.borrarMensaje();
  this.notificaSrv.emiter
  .subscribe((d:any)=>{
    this.mensaje = d.mensaje;
    this.tipo = d.tipo
    this.borrarMensaje();
  })

  }
  ngOnInit() {
  }

  borrarMensaje(){
    setTimeout(()=>{
      this.mensaje = null;
      this.tipo = null;
    },2000)
  }

}
