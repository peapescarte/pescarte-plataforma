defmodule Pescarte.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string, null: false
      add :public_id, :string
      add :categoria_id, references("categorias"), null: false

      timestamps()
    end

    create index(:tags, [:label])
    create index(:tags, [:categoria_id])

    alter table(:midia) do
      remove :tags
    end
  end
end
