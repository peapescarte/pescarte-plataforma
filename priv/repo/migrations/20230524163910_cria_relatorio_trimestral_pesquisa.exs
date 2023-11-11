defmodule Pescarte.ModuloPesquisa.Repo.Migrations.CriaRelatorioTrimestralPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_trimestral_pesquisa, primary_key: false) do
      add :ano, :smallint, null: false, primary_key: true
      add :mes, :smallint, null: false, primary_key: true
      add :link, :string
      add :id_publico, :string, null: false
      add :status, :string, null: false
      add :data_entrega, :date

      add :titulo, :text
      add :resumo, :text
      add :introducao, :text
      add :embasamento_teorico, :text
      add :resultados_preliminares, :text
      add :atividades_academicas, :text
      add :atividades_nao_academicas, :text
      add :referencias, :text

      add :pesquisador_id, references(:pesquisador, column: :id_publico, type: :string),
        null: false

      timestamps()
    end

    create unique_index(:relatorio_trimestral_pesquisa, [:ano, :mes])
    create index(:relatorio_trimestral_pesquisa, [:pesquisador_id])
  end
end
