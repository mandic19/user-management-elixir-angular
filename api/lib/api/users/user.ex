defmodule Api.Users.User do
  use Api, :model

  use Ecto.Schema

  import Ecto.Changeset

  alias Api.Users.Permission
  alias Api.Users.UserPermission

  @derive {Jason.Encoder, only: [
    :id,
    :first_name,
    :last_name,
    :username,
    :email,
    :status,
    :permissions
  ]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :email, :string
    field :status, :string

    many_to_many(
      :permissions,
      Permission,
      join_through: UserPermission,
      on_replace: :delete
    )

    field(:deleted_at, :utc_datetime_usec)
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :username,
      :email,
      :status,
      :password
    ])
    |> validate_required([
      :username,
      :email
    ])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 3, max: 16)
    |> set_pw_hash()
  end

  defp set_pw_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp set_pw_hash(changeset), do: changeset
end
