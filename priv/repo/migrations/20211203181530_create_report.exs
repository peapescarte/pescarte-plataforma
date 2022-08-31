defmodule Fuschia.Repo.Migrations.CreateReport do
  use Ecto.Migration

  def change do
    create table(:report) do
      add :public_id, :string
      add :year, :smallint, null: false
      add :month, :smallint, null: false
      add :type, :string, null: false
      add :link, :string
      add :researcher_id, references(:researcher), null: false

      timestamps()
    end

    create unique_index(:report, [:year, :month])
    create index(:report, [:researcher_id])
  end
end
