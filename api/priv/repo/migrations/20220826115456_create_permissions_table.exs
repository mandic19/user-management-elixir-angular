defmodule Api.Repo.Migrations.CreatePermissionsTable do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :code, :string, size: 64, null: false
      add :description, :string, size: 255, null: false

      add(:deleted_at, :timestamptz)
      timestamps(type: :timestamptz)
    end
  end
end
