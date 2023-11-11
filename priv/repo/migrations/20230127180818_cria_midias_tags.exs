defmodule Pescarte.ModuloPesquisa.Repo.Migrations.CriaMidiaTag do
  use Ecto.Migration

  def change do
    create table(:midias_tags, primary_key: false) do
      add :midia_link, references(:midia, column: :link, type: :string)
      add :tag_etiqueta, references(:tag, column: :etiqueta, type: :string)
    end
  end
end
