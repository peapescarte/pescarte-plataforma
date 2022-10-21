defmodule Backend.Repo.Migrations.CreateCampus do
  use Ecto.Migration

  def change do
    create table(:campus) do
      add :initials, :string, null: false
      add :name, :string
      add :public_id, :string
      add :city_id, references(:city), null: false

      timestamps()
    end

    create unique_index(:campus, [:initials])
    create unique_index(:campus, [:city_id, :initials])
  end
end
