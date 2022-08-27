import {Component, Input, OnInit} from '@angular/core';
import {UserService} from "../services/user.service";
import {Subject, Subscription} from "rxjs";
import {IUser} from "../user";
import {debounceTime, distinctUntilChanged} from "rxjs/operators";
import {UserStatusHelper} from "../helpers/user-status-helper";

@Component({
  selector: 'ecm-user-table',
  templateUrl: './user-table.component.html',
  styleUrls: ['./user-table.component.css']
})
export class UserTableComponent implements OnInit {
  users: IUser[] = [];
  page_size: number = 10;
  page_number: number = 1;
  total_pages: number = 1;
  sort: string = '';
  @Input() searchInput: string = '';
  sub!: Subscription;

  searchInputUpdate = new Subject<string>();

  constructor(private userService: UserService) {
    this.searchInputUpdate.pipe(
      debounceTime(400),
      distinctUntilChanged())
      .subscribe(value => {
        this.fetchUsers();
      });
  }

  ngOnInit(): void {
    this.fetchUsers();
  }

  ngOnDestroy(): void {
    this.sub.unsubscribe();
  }

  handleError(err): void {
    console.log(err.m);
  }

  toggleSort(key: string) {
    this.sort = this.sort === key ? "-" + key : key;

    this.fetchUsers();
  }

  setPageNumber(number: number) {
    if(number < 1) {
      this.page_number = 1;
    } else if(number > this.total_pages) {
      this.page_number = this.total_pages
    } else {
      this.page_number = number;
    }

    this.fetchUsers();
  }

  private fetchUsers() {
    let params = {
      page: this.page_number,
      sort: this.sort,
      q: this.searchInput
    }

    this.sub = this.userService.getUsers(params).subscribe({
      next: res => {
        this.users = res.results
        this.total_pages = res.total_pages;
        this.page_size = res.page_size;
        this.page_number = res.page_number;
      },
      error: err => this.handleError(err)
    });
  }

  deleteUser(id: any) {
    if(confirm("Are you sure you want to delete this user ?")) {
      this.sub = this.userService.deleteUser(id).subscribe({
        next: res => {
          this.users = this.users.filter(u => u.id != id);
        },
        error: err => this.handleError(err)
      });
    }
  }
}
