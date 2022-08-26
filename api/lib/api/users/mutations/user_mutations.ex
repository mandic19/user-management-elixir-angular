defmodule Api.Users.Mutations.UserMutations do
  use Api, :mutation

  alias Api.Users.User

  def build_user_changeset(struct \\ %User{}, params \\ %{}),
    do: User.changeset(struct, params)

  def create_user_changeset(params),
    do: build_user_changeset(%User{}, params)

  def update_user_changeset(%User{} = user, params \\ %{}),
    do: build_user_changeset(user, params)

  def delete_user_changeset(%User{} = user, _params \\ %{}) do
    user
    |> User.changeset()
    |> put_change(:deleted_at, DateTime.utc_now())
  end
end
