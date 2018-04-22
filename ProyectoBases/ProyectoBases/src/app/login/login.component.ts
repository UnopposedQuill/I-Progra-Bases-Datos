import { Component, OnInit } from '@angular/core';
import { NotificationService } from '../shared/notification/notification.service';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { VariableService } from '../shared/variable.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styles: []
})

export class LoginComponent implements OnInit {
  frmLogin : FormGroup;
  constructor(private notificaSvr: NotificationService,
    private fb: FormBuilder,
    private variableSrv:VariableService
  ) { 
    this.frmLogin = this.fb.group({
      'email': ['',Validators.email],
      'carnet': ['',Validators.required],
    })
  }
  ngOnInit() {
  }

  login(){
    const frm = this.frmLogin.value;
    this.variableSrv.bLoggIn.next(true);
    this.variableSrv.bLoggUser.next(true);

  }


}
