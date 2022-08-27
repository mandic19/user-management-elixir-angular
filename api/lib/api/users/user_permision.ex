defmodule Api.Users.UserPermission do
  use Ecto.Schema

  import Ecto.Changeset

  alias Api.Users.User
  alias Api.Users.Permission

  schema "users_permissions" do
    belongs_to :users, User, foreign_key: :user_id
    belongs_to :permissions, Permission, foreign_key: :permission_id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :permission_id,
      :user_id,
    ])
    |> validate_required([
      :permission_id,
      :user_id
    ])
  end
end
