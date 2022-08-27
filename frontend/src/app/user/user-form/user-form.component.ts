import {Component, Input, OnInit} from '@angular/core';
import {UserService} from "../services/user.service";
import {FormBuilder, FormGroup} from "@angular/forms";
import {IUser} from "../user";
import {Subscription} from "rxjs";
import {ActivatedRoute, Router} from "@angular/router";

@Component({
  selector: 'ecm-user-form',
  templateUrl: './user-form.component.html',
  styleUrls: ['./user-form.component.css']
})

export class UserFormComponent {
  sub!: Subscription;
  user: IUser;
  userId: string;
  isNewRecord: boolean = true;
  userForm = this.formBuilder.group({
    id: null,
    first_name: '',
    last_name: '',
    email: '',
    status: '',
    username: '',
    password: ''
  });

  ngOnInit(): void {
    this.userId = this.activatedRoute.snapshot.paramMap.get('id');
    this.isNewRecord = this.userId === null;
    console.log(this.userId);

    if(!this.isNewRecord) {
      this.sub = this.userService.getUser(this.userId).subscribe({
        next: user => {
          this.user = user
          this.userForm = this.formBuilder.group({
            id: this.user?.id,
            first_name: this.user?.first_name,
            last_name: this.user?.last_name,
            email: this.user?.email,
            status: this.user?.status,
          });
        },
        error: err => this.handleError(err)
      });
    }
  }

  handleError(err): void {
    console.log(err.m);
  }

  constructor(
    private userService: UserService,
    private formBuilder: FormBuilder,
    private activatedRoute: ActivatedRoute,
    private router: Router
  ) {
  }

  onSubmit(): void {
    if(!this.isNewRecord) {
      this.sub = this.userService.updateUser(this.userId, this.userForm.value).subscribe({
        next: user => {
          this.user = user
          this.router.navigate(['/users']).then(r => {
          })
        },
        error: err => this.handleError(err)
      });
    } else {
      this.sub = this.userService.createUser(this.userForm.value).subscribe({
        next: user => {
          this.user = user
          this.router.navigate(['/users']).then(r => {
          })
        },
        error: err => this.handleError(err)
      });
    }
  }
}
