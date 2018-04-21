import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class NotificationService {
  private subject = new Subject<any>();
  public emiter = this.subject.asObservable();

  show(tipo,mensaje){
    this.subject.next({tipo,mensaje});
  }
}
