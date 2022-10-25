defmodule Pescarte.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string, null: false
      add :public_id, :string
      add :midia_id, references(:midia), null: false
      add :category_id, references(:category), null: false

      timestamps()
    end

    create index(:tags, [:label])
    create unique_index(:tags, [:midia_id])
    create unique_index(:tags, [:category_id])

    alter table(:midia) do
      remove :tags
    end
  end
end
