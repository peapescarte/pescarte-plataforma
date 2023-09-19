defmodule Database.Repo.Migrations.CriaRelatorioPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_pesquisa, primary_key: false) do
      add :id_publico, :string, null: false
      add :tipo, :string, null: false
      add :conteudo, :map, null: false
      add :inicio_periodo, :date, null: false
      add :fim_periodo, :date, null: false
      add :link, :string
      add :status, :string

      add :pesquisador_id, references(:pesquisador, column: :id_publico, type: :string),
        null: false

      timestamps()
    end
  end
end
