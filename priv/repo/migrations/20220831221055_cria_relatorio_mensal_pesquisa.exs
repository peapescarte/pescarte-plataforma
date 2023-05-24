defmodule Pescarte.Repo.Migrations.CreateRelatorioMensal do
  use Ecto.Migration

  def change do
    create table(:relatorio_mensal_pesquisa) do
      # Primeira seção
      add :acao_planejamento, :text
      add :participacao_grupos_estudo, :text
      add :acoes_pesquisa, :text
      add :participacao_treinamentos, :text
      add :publicacao, :text

      # Segunda seção
      add :next_planning_action, :text
      add :next_study_group, :text
      add :next_guidance_metting, :text
      add :next_research_actions, :text

      add :ano, :smallint, null: false
      add :mes, :smallint, null: false
      add :link, :string
      add :id_publico, :string

      add :pesquisador_id, references(:pesquisador), null: false

      timestamps()
    end

    create unique_index(:relatorio_mensal_pesquisa, [:ano, :mes])
    create index(:relatorio_mensal_pesquisa, [:pesquisador_id])
  end
end
