defmodule Pescarte.ModuloPesquisa.Repo.Migrations.CriaRelatorioPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_pesquisa, primary_key: false) do
      add :id_publico, :string
      add :tipo, :string, null: false
      add :conteudo, :map, null: false
      add :data_inicio, :date, primary_key: true
      add :data_fim, :date, primary_key: true
      add :data_entrega, :date
      add :data_limite, :date, null: false
      add :link, :string
      add :status, :string

      add :pesquisador_id, references(:pesquisador, column: :id_publico, type: :string), primary_key: true

      timestamps()
    end
  end
end
