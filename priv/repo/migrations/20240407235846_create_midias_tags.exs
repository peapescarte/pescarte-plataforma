defmodule Pescarte.Database.Repo.Migrations.CreateMidiasTags do
  use Ecto.Migration

  def change do
    create table(:midias_tags) do
      add :midia_id, references(:midia, type: :string), null: false
      add :tag_id, references(:tag, type: :string), null: false
    end

    create index(:midias_tags, [:midia_id])
    create index(:midias_tags, [:tag_id])
  end
end
