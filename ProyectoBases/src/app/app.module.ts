import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';


import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { LoginComponent } from './login/login.component';
import { RegistroComponent } from './registro/registro.component';
import { MenuComponent } from './shared/menu/menu.component';
import { RouterModule } from '@angular/router';
import { RouterConfig } from './router.config';


@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    LoginComponent,
    RegistroComponent,
    MenuComponent
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(RouterConfig)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
