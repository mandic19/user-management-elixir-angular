import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {AppComponent} from './app.component';
import {HeaderComponent} from './core/header/header.component';
import {FooterComponent} from './core/footer/footer.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {RouterModule} from '@angular/router';
import {PageNotFoundComponent} from './core/page-not-found/page-not-found.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {HttpClient, HttpClientModule} from '@angular/common/http';
import { UserTableComponent } from './user/user-table/user-table.component';
import {UserFormComponent} from "./user/user-form/user-form.component";
import {UserPermissionsFormComponent} from "./user/user-permissions-form/user-permissions-form.component";

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    PageNotFoundComponent,
    UserTableComponent,
    UserFormComponent,
    UserPermissionsFormComponent
  ],
    imports: [
        BrowserModule,
        HttpClientModule,
        BrowserAnimationsModule,
        ReactiveFormsModule,
        RouterModule.forRoot([
            {path: '', component: UserTableComponent},
            {path: 'users', component: UserTableComponent},
            {path: 'users/create', component: UserFormComponent},
            {path: 'users/:id', component: UserFormComponent},
            {path: 'users/:id/permissions', component: UserPermissionsFormComponent},
            {path: '**', component: PageNotFoundComponent}
        ]),
        FormsModule,
    ],
  providers: [],
  bootstrap: [AppComponent]
})

export class AppModule {
}
