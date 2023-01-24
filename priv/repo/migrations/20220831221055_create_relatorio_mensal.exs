defmodule Pescarte.Repo.Migrations.CreateRelatorioMensal do
  use Ecto.Migration

  def change do
    create table(:relatorio_mensal) do
      # Primeira seção
      add :planning_action, :text
      add :study_group, :text
      add :guidance_metting, :text
      add :research_actions, :text
      add :training_participation, :text
      add :publication, :text

      # Segunda seção
      add :next_planning_action, :text
      add :next_study_group, :text
      add :next_guidance_metting, :text
      add :next_research_actions, :text

      add :year, :smallint, null: false
      add :month, :smallint, null: false
      add :link, :string
      add :public_id, :string
      add :pesquisador_id, references(:pesquisador), null: false

      timestamps()
    end

    create unique_index(:relatorio_mensal, [:year, :month])
    create index(:relatorio_mensal, [:pesquisador_id])
  end
end
