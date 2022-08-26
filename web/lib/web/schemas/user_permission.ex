defmodule Web.Schemas.UserPermission do
  use Ecto.Schema
  
  alias Web.Schemas.User
  alias Web.Schemas.Permission

  schema "users_permissions" do
    belongs_to :users, User, foreign_key: :user_id
    belongs_to :permissions, Permission, foreign_key: :permission_id
  end
end
