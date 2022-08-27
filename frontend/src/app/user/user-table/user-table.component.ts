import {Component, Input, OnDestroy, OnInit} from '@angular/core';
import {UserService} from '../services/user.service';
import {Subject, Subscription} from 'rxjs';
import {IUser} from '../user';
import {debounceTime, distinctUntilChanged} from 'rxjs/operators';

@Component({
  selector: 'ecm-user-table',
  templateUrl: './user-table.component.html',
  styleUrls: ['./user-table.component.css']
})
export class UserTableComponent implements OnInit, OnDestroy {
  TABLE_COLUMNS = [
    {key: 'id', label: 'ID'},
    {key: 'first_name', label: 'First Name'},
    {key: 'last_name', label: 'Last Name'},
    {key: 'username', label: 'Username'},
    {key: 'email', label: 'Email'},
    {key: 'status', label: 'Status'},
  ];

  users: IUser[] = [];
  pageSize = 10;
  pageNumber = 1;
  totalPages = 1;
  sort = '';
  @Input() searchInput = '';
  sub!: Subscription;

  searchInputUpdate = new Subject<string>();

  constructor(private userService: UserService) {
    this.searchInputUpdate.pipe(
      debounceTime(400),
      distinctUntilChanged())
      .subscribe(value => {
        this.fetchAndSetUsers();
      });
  }

  ngOnInit(): void {
    this.fetchAndSetUsers();
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  handleError(err): void {
    console.log(err.m);
  }

  toggleSort(key: string): void {
    this.sort = this.sort === key ? '-' + key : key;

    this.fetchAndSetUsers();
  }

  getSortIconClassList(key: string): string {
    let classList = ['fa ms-2'];

    if (key === this.sort) {
      classList.push('fa-sort-amount-asc');
    } else if (this.sort === '-' + key) {
      classList.push('fa-sort-amount-desc');
    } else {
      classList.push('fa-sort');
    }

    return classList.join(' ');
  }

  setPageNumber(number: number): void {
    if (number < 1) {
      this.pageNumber = 1;
    } else if (number > this.totalPages) {
      this.pageNumber = this.totalPages;
    } else {
      this.pageNumber = number;
    }

    this.fetchAndSetUsers();
  }

  private fetchAndSetUsers(): void {
    const params = {
      page: this.pageNumber,
      sort: this.sort,
      q: this.searchInput
    };

    this.sub = this.userService.getUsers(params).subscribe({
      next: res => {
        this.users = res.results;
        this.totalPages = res.total_pages;
        this.pageSize = res.page_size;
        this.pageNumber = res.page_number;
      },
      error: err => this.handleError(err)
    });
  }

  deleteUser(id: any): void {
    if (confirm('Are you sure you want to delete this user ?')) {
      this.sub = this.userService.deleteUser(id).subscribe({
        next: res => {
          this.users = this.users.filter(u => u.id !== id);
        },
        error: err => this.handleError(err)
      });
    }
  }
}
