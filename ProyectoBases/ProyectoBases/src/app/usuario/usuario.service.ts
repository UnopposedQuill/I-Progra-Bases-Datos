import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Usuario } from './usuario';
import { Grupo } from './grupo';

@Injectable()
export class UsuarioService {
  api: string = 'api/usuarios';
  headers = new HttpHeaders({ 'Content-Type': 'application/json' });
  constructor(private http: HttpClient) {}

    getUsuario(){
      return this.http.get(this.api).toPromise();
    }

    getCodigoGrupo(){
      return this.http.get('api/grupo').toPromise()
    }


    grabar(usuario: Usuario){
      return this.http.post(this.api,
        JSON.stringify(usuario),
        { headers: this.headers }).toPromise();
    }


     agregar() {

    }
}
