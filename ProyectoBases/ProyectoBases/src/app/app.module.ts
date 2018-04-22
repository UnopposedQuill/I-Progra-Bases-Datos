import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegistroComponent } from './registro/registro.component';
import { MenuComponent } from './shared/menu/menu.component';
import { RouterModule } from '@angular/router';
import { RouterConfig } from './router.config';
import { NotificationComponent } from './shared/notification/notification.component';
import { NotificationService } from './shared/notification/notification.service';
import { UsuarioComponent } from './usuario/usuario.component';
import { UsuarioService } from './usuario/usuario.service';
import { VariableService } from './shared/variable.service';
import { UsuarioContenidoComponent } from './usuario/usuario-contenido/usuario-contenido.component';
import { RegistroNotasComponent } from './registro-notas/registro-notas.component';


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    LoginComponent,
    RegistroComponent,
    MenuComponent,
    NotificationComponent,
    UsuarioComponent,
    UsuarioContenidoComponent,
    RegistroNotasComponent
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(RouterConfig),
    HttpClientModule,
    ReactiveFormsModule

  ],
  providers: [NotificationService, UsuarioService,VariableService],
  bootstrap: [AppComponent]
})
export class AppModule { }
