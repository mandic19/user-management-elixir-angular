defmodule Api.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string, size: 64, null: false
      add :password_hash, :string
      add :email, :string, size: 64, null: false
      add :status, :string

      timestamps(type: :timestamptz)
    end
  end
end
