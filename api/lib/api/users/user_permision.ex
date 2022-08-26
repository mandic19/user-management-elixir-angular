defmodule Api.Users.UserPermission do
  use Ecto.Schema

  alias Api.Users.User
  alias Api.Users.Permission

  schema "users_permissions" do
    belongs_to :users, User, foreign_key: :user_id
    belongs_to :permissions, Permission, foreign_key: :permission_id

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end
end
