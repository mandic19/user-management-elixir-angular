defmodule Web.Schemas.User do
    use Ecto.Schema

    import Ecto.Changeset

    alias Web.Schemas.Permission
    alias Web.Schemas.UserPermission

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

    defmodule Query do
      defstruct []
    end

    def query_changeset(struct, params \\ %{}) do
      types = %{
        id: :integer,
        first_name: :string,
        last_name: :string,
        username: :string,
        email: :string,
        status: :string
      }

      {struct, types}
      |> cast(params, Map.keys(types))
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
    end
end
