defmodule Web.Schemas.Permission do
  use Ecto.Schema
  
  import Ecto.Changeset

  alias Web.Schemas.User
  alias Web.Schemas.UserPermission

  @derive {Jason.Encoder, only: [
    :code,
    :description
  ]}

  schema "permissions" do
    field :code, :string
    field :description, :string

    many_to_many(
      :users,
      User,
      join_through: UserPermission,
      on_replace: :delete
    )
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:code, :description])
    |> validate_required([:code, :description])
  end
end
