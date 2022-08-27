import {Injectable} from "@angular/core";
import {environment} from "../../../environments/environment";
import {HttpClient} from "@angular/common/http";
import {Observable} from "rxjs";
import {IUser} from "../user";
import {IUserPagination} from "../user-pagination";

@Injectable({
  providedIn: 'root'
})

export class UserService {
  baseUrl: string = environment.apiUrl + '/users'

  constructor(private http: HttpClient) {
  }

  getUser(id: string): Observable<IUser> {
    return this.http.get<IUser>(this.baseUrl + "/" + id);
  }

  getUsers(params: any = {}): Observable<IUserPagination> {
    return this.http.get<IUserPagination>(this.baseUrl, {params: params});
  }

  createUser(body: any = {}, params: any = {}): Observable<any> {
    return this.http.post<IUser>(this.baseUrl, body, params);
  }

  updateUser(id: string, body: any = {}, params: any = {}): Observable<any> {
    return this.http.put<IUser>(this.baseUrl  + "/" + id, body, params);
  }

  deleteUser(id: string, params: any = {}): Observable<any> {
    return this.http.delete<any>(this.baseUrl + "/" + id, params);
  }

  updateUserPermissions(id: string, body: any = {}, params: any = {}): Observable<any> {
    return this.http.put<IUser>(this.baseUrl  + "/" + id + "/permissions", body, params);
  }
}
