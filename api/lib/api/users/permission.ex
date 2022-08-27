defmodule Api.Users.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Users.User
  alias Api.Users.UserPermission

  @derive {Jason.Encoder, only: [
    :id,
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

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:code, :description])
    |> validate_required([:code, :description])
    |> unique_constraint(:code, message: "Permission already exists!")
  end
end
