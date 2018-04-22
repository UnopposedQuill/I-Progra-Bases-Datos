import { Route } from "@angular/router";
import { HomeComponent } from "./home/home.component";
import { LoginComponent } from "./login/login.component";
import { UsuarioComponent } from "./usuario/usuario.component";
import { RegistroComponent } from "./registro/registro.component";
import { RegistroNotasComponent } from './registro-notas/registro-notas.component';



export const RouterConfig: Route[]=[
    {path: 'home',component: HomeComponent},
    {path: 'usuario',component: UsuarioComponent},
    {path: 'registro',component: RegistroComponent},
    {path: 'registroNotas',component: RegistroNotasComponent},  
    {path: 'login',component: LoginComponent},
    {path: '',redirectTo:'home', pathMatch: "full"},
    {path: '**',redirectTo:'home'},
]

