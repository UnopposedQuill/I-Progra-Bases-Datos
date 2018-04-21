import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';


@Injectable()
export class VariableService {
  public bLoggIn = new BehaviorSubject(false);
  public bLoggUser= new BehaviorSubject(false);
  constructor() { }

}
