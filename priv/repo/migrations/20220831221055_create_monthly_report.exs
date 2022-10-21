defmodule Backend.Repo.Migrations.CreateMonthlyReport do
  use Ecto.Migration

  def change do
    create table(:monthly_report) do
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
      add :researcher_id, references(:researcher), null: false

      timestamps()
    end

    create unique_index(:monthly_report, [:year, :month])
    create index(:monthly_report, [:researcher_id])
  end
end
