import {Component, Input, OnDestroy, OnInit} from '@angular/core';
import {UserService} from "../services/user.service";
import {FormArray, FormBuilder, FormControl, FormGroup} from "@angular/forms";
import {IUser} from "../user";
import {Subscription} from "rxjs";
import {ActivatedRoute, Router} from "@angular/router";
import {PermissionService} from "../../permission/services/permission-service";
import {IPermission} from "../../permission/permission";

@Component({
  selector: 'ecm-user-form',
  templateUrl: './user-permissions-form.component.html',
  styleUrls: ['./user-permissions-form.component.css']
})

export class UserPermissionsFormComponent implements OnInit, OnDestroy {
  sub!: Subscription;
  user: IUser;
  permissions: IPermission[];
  userId: string;
  selectedPermissionIds: number[];

  ngOnInit(): void {
    this.userId = this.activatedRoute.snapshot.paramMap.get('id');

    this.sub = this.userService.getUser(this.userId).subscribe({
      next: user => {
        this.user = user;
        this.selectedPermissionIds = user.permissions.map(x => x.id)
      },
      error: err => this.handleError(err)
    });

    this.sub = this.permissionService.getPermissions().subscribe({
      next: permissions => {
        this.permissions = permissions
      },
      error: err => this.handleError(err)
    });
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  handleError(err): void {
    console.log(err.m);
  }

  constructor(
    private userService: UserService,
    private permissionService: PermissionService,
    private fb: FormBuilder,
    private activatedRoute: ActivatedRoute,
    private router: Router,
  ) {
  }

  onCheckChange(event): void {
    let permission_id = parseInt(event.target.value);

    let index = this.selectedPermissionIds.indexOf(permission_id);

    if (index === -1) {
      this.selectedPermissionIds.push(permission_id);
    } else {
      this.selectedPermissionIds.splice(index, 1);
    }
  }

  onSubmit(): void {
    let body = {
      permission_ids: this.selectedPermissionIds
    };

    this.sub = this.userService.updateUserPermissions(this.userId, body).subscribe({
      next: user => {
        this.user = user
        this.router.navigate(['/users']).then(r => {
        })
      },
      error: err => this.handleError(err)
    });
  }
}
