defmodule Fuschia.Repo.Migrations.CreateRelatorio do
  use Ecto.Migration

  def change do
    create table("relatorio", primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :ano, :smallint, null: false
      add :mes, :smallint, null: false
      add :tipo, :string, null: false
      add :link, :string
      add :pesquisador_id, references(:pesquisador, type: :string)

      timestamps()
    end

    create unique_index(:relatorio, [:ano, :mes])
    create index(:relatorio, [:pesquisador_id])
  end
end
