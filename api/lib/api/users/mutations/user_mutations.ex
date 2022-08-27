defmodule Api.Users.Mutations.UserMutations do
  use Api, :mutation
  import Ecto.Query

  alias Api.Users.User
  alias Api.Users.UserPermission

  def build_user_changeset(struct \\ %User{}, params \\ %{}),
    do: User.changeset(struct, params)

  def build_user_permission_changeset(struct \\ %UserPermission{}, params \\ %{}),
    do: UserPermission.changeset(struct, params)

  def create_user_changeset(params),
    do: build_user_changeset(%User{}, params)

  def update_user_changeset(%User{} = user, params \\ %{}),
    do: build_user_changeset(user, params)

  def update_user_permission_changeset(%UserPermission{} = user_permission, params \\ %{}),
    do: build_user_permission_changeset(user_permission, params)

  def delete_user_changeset(%User{} = user, _params \\ %{}) do
    user
    |> User.changeset()
    |> put_change(:deleted_at, DateTime.utc_now())
  end

  def update_permissions_multi(%User{} = user, %{permission_ids: permission_ids}) do
    current_permission_ids = Enum.map(user.permissions, & &1.id)
    new_permission_ids = permission_ids -- current_permission_ids
    loose_permission_ids = current_permission_ids -- permission_ids

    deleted_at = DateTime.utc_now()

    Multi.new()
    |> Multi.delete_all(
      :delete_user_permissions,
      fn _ ->
        from(up in UserPermission,
          where:
            is_nil(up.deleted_at) and (up.permission_id in ^loose_permission_ids) and up.user_id == ^user.id
        )
      end,
      []
    )
    |> Multi.run(:permission, fn _repo, _ ->
      case add_user_permissions(user, new_permission_ids) do
        {:error, error} -> {:error, error}
        _ -> {:ok, user}
      end
    end)
  end

  defp add_user_permissions(user, [permission_id | permission_ids]) do
    user_permission = %UserPermission{
      permission_id: permission_id,
      user_id: user.id
    }

    user_permission
    |> update_user_permission_changeset()
    |> Api.Repo.insert()

    add_user_permissions(user, permission_ids)
  end

  defp add_user_permissions(_, _), do: nil
end
