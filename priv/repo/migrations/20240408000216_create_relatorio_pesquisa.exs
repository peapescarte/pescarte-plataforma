defmodule Pescarte.Database.Repo.Migrations.CreateRelatorioPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_pesquisa, primary_key: false) do
      add :id, :string, primary_key: true
      add :link, :string
      add :data_inicio, :date
      add :data_fim, :date
      add :data_entrega, :date
      add :data_limite, :date
      add :tipo, :string, null: false
      add :status, :string, null: false
      add :conteudo, :map, null: false
      add :pesquisador_id, references(:pesquisador, type: :string), null: false

      timestamps()
    end

    create index(:relatorio_pesquisa, [:pesquisador_id])
  end
end
