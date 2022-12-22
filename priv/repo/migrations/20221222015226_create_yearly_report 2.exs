defmodule Pescarte.Repo.Migrations.YearlyReport do
  use Ecto.Migration

  def change do

    create table(:yearly_report) do

      add :plan, :text
      add :abstract, :text
      add :introduction, :text
      add :theoretical_embasement, :text
      add :results, :text
      add :academic_activities, :text
      add :non_academic_activities, :text
      add :conclusion, :text
      add :references, :text

      add :year, :integer
      add :month, :integer
      add :link, :string
      add :public_id, :string

      add :status, :string

      add :researcher_id, references(:researcher), null: false

      timestamps()

    end

    create unique_index(:yearly_report, [:year, :month])
    create index(:yearly_report, [:researcher_id])

  end
end
