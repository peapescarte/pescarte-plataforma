defmodule Pescarte.Database.Repo.Migrations.CreateMideia do
  use Ecto.Migration

  def change do
    create table(:midia, primary_key: false) do
      add :id, :string, primary_key: true
      add :link, :string, null: false
      add :tipo, :string, null: false
      add :nome_arquivo, :string, null: false
      add :data_arquivo, :date, null: false
      add :restrito?, :boolean, default: false
      add :observacao, :string
      add :texto_alternativo, :string
      add :autor_id, references(:usuario, type: :string), null: false

      timestamps()
    end

    create index(:midia, [:autor_id])
  end
end
