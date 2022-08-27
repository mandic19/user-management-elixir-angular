import {IUser} from "./user";

export interface IUserPagination {
  results: IUser[];
  page_number: number;
  page_size: number;
  total_pages: number;
}
