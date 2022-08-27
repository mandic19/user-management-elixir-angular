import {Component} from '@angular/core';
import {Subscription} from 'rxjs';

@Component({
  selector: 'ecm-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'User Management System';
  sub!: Subscription;
}
