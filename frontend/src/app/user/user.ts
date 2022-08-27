import {IPermission} from "../permission/permission";

export interface IUser {
  id: number;
  first_name: string;
  last_name: string;
  username: string;
  email: string;
  status: string;
  permissions: IPermission[];
}
