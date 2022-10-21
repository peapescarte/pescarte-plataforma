defmodule Backend.Repo.Migrations.CreateMidia do
  use Ecto.Migration

  def change do
    create table("midia") do
      add :public_id, :string
      add :type, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false
      add :researcher_id, references(:researcher), null: false

      timestamps()
    end

    create unique_index(:midia, [:link])
    create index(:midia, [:researcher_id])
  end
end
