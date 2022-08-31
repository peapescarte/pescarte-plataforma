defmodule Fuschia.Repo.Migrations.CreateResearchCore do
  use Ecto.Migration

  def change do
    create table(:research_core) do
      add :name, :string, null: false
      add :desc, :string, size: 400, null: false
      add :public_id, :string, null: false

      timestamps()
    end
  end
end
