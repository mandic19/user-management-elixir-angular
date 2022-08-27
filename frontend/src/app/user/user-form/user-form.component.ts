import {Component, Input, OnDestroy, OnInit} from '@angular/core';
import {UserService} from '../services/user.service';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {IUser} from '../user';
import {Subscription} from 'rxjs';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'ecm-user-form',
  templateUrl: './user-form.component.html',
  styleUrls: ['./user-form.component.css']
})

export class UserFormComponent implements OnInit, OnDestroy {
  sub!: Subscription;
  user: IUser;
  userId: string;
  isNewRecord: boolean = true;
  isSubmitted: boolean = false;
  userForm: FormGroup;

  ngOnInit(): void {
    this.userId = this.activatedRoute.snapshot.paramMap.get('id');
    this.isNewRecord = this.userId === null;

   this.userForm = this.formBuilder.group({
      id: null,
      first_name: '',
      last_name: '',
      email: ['', [Validators.required, Validators.email]],
      status: ['', [Validators.required]],
      username: ['', [Validators.required]],
      password: ['', [
        Validators.required,
        Validators.minLength(3),
        Validators.maxLength(16)
      ]],
    });

    if (!this.isNewRecord) {
      this.sub = this.userService.getUser(this.userId).subscribe({
        next: user => {
          this.user = user;
          this.userForm.patchValue({
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

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
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
    this.isSubmitted = true;

    if(this.userForm.invalid) {
      return;
    }

    if (!this.isNewRecord) {
      this.sub = this.userService.updateUser(this.userId, this.userForm.value).subscribe({
        next: user => {
          this.user = user;
          this.router.navigate(['/users']).then(r => {
          });
        },
        error: err => this.handleError(err)
      });
    } else {
      this.sub = this.userService.createUser(this.userForm.value).subscribe({
        next: user => {
          this.user = user;
          this.router.navigate(['/users']).then(r => {
          });
        },
        error: err => this.handleError(err)
      });
    }
  }

  isInvalidField(fieldName: string): boolean {
    let formControl = this.userForm.get(fieldName);
    return this.isSubmitted && !formControl.valid;
  }
}
