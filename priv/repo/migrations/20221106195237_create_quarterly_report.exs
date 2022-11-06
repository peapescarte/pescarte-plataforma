defmodule Pescarte.Repo.Migrations.CreateQuarterlyReport do
  use Ecto.Migration

  def change do

    create table(:quarterly_report) do

      add :title, :text
      add :abstract, :text
      add :introduction, :text
      add :theoretical_embasement, :text
      add :preliminary_results, :text
      add :academic_activities, :text
      add :non_academic_activities, :text
      add :references, :text

      add :year, :integer
      add :month, :integer
      add :link, :string
      add :public_id, :string

      add :researcher_id, references(:researcher), null: false

      timestamps()

    end

    create unique_index(:quarterly_report, [:year, :month])
    create index(:quarterly_report, [:researcher_id])

  end
end
