defmodule Pescarte.Repo.Migrations.CriaRelatorioTrimestralPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_trimestral_pesquisa) do
      add :ano, :smallint, null: false
      add :mes, :smallint, null: false
      add :link, :string
      add :id_publico, :string, null: false
      add :status, :string, null: false

      add :titulo, :text
      add :resumo, :text
      add :introducao, :text
      add :embasamento_teorico, :text
      add :resultados_preliminares, :text
      add :atividades_academicas, :text
      add :atividades_nao_academicas, :text
      add :referencias, :text

      add :pesquisador_id, references(:pesquisador), null: false
    end

    create unique_index(:relatorio_trimestral_pesquisa, [:ano, :mes])
    create index(:relatorio_trimestral_pesquisa, [:pesquisador_id])
  end
end
