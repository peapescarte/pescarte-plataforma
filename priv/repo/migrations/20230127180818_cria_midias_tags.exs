defmodule Pescarte.Repo.Migrations.CriaMidiaTag do
  use Ecto.Migration

  def change do
    create table(:midias_tags, primary_key: false) do
      add :midia_id, references(:midia)
      add :tag_id, references(:tag)
    end
  end
end
