import { HomeComponent } from "./home/home.component";
import { Route } from "@angular/router";
import { LoginComponent } from "./login/login.component";

export const RouterConfig: Route[] = [
    {path: 'home' , component:HomeComponent},
    {path: 'usuario', component:HomeComponent},
    {path: 'registro', component:HomeComponent},
    {path: 'login', component:LoginComponent},
    {path: '', redirectTo: 'home', pathMatch: "full"},
    {path: '**', redirectTo: 'home'},
]