defmodule Pescarte.Repo.Migrations.CriaRelatorioAnualPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_anual_pesquisa) do
      add :ano, :smallint, null: false
      add :mes, :smallint, null: false
      add :link, :string
      add :id_publico, :string, null: false
      add :status, :string, null: false

      add :plano_de_trabalho, :text
      add :resumo, :text
      add :introducao, :text
      add :embasamento_teorico, :text
      add :resultados, :text
      add :atividades_academicas, :text
      add :atividades_nao_academicas, :text
      add :conclusao, :text
      add :referencias, :text

      add :pesquisador_id, references(:pesquisador), null: false

      timestamps()
    end

    create unique_index(:relatorio_anual_pesquisa, [:ano, :mes])
    create index(:relatorio_anual_pesquisa, [:pesquisador_id])
  end
end
