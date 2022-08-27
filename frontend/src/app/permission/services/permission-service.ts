import {Injectable} from "@angular/core";
import {environment} from "../../../environments/environment";
import {HttpClient} from "@angular/common/http";
import {Observable} from "rxjs";
import {IUser} from "../../user/user";
import {IUserPagination} from "../../user/user-pagination";
import {IPermission} from "../permission";

@Injectable({
  providedIn: 'root'
})

export class PermissionService {
  baseUrl: string = environment.apiUrl + '/permissions'

  constructor(private http: HttpClient) {
  }

  getPermissions(params: any = {}): Observable<IPermission[]> {
    return this.http.get<IPermission[]>(this.baseUrl, {params: params});
  }
}
