import { Component, OnInit } from '@angular/core';
import { VariableService } from '../variable.service';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {
  loggedIn : boolean = false;
  loggedUser: boolean = false;
  constructor(
    private varableSrv: VariableService
  ) { }

  ngOnInit() {
    this.varableSrv.bLoggIn.subscribe(
      v => this.loggedIn = v
    )
    this.varableSrv.bLoggUser.subscribe(
      c => this.loggedUser = c
    )
  }

  logout(){
    this.varableSrv.bLoggIn.next(false);
    this.varableSrv.bLoggUser.next(false)
  }

}
