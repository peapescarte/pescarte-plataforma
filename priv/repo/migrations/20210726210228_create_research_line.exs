defmodule Backend.Repo.Migrations.CreateResearchLine do
  use Ecto.Migration

  def change do
    create table(:research_line) do
      add :public_id, :string
      add :number, :integer, null: false
      add :short_desc, :string, size: 90, null: false
      add :desc, :string, size: 280
      add :research_core_id, references(:research_core), null: false

      timestamps()
    end

    create unique_index(:research_line, [:number])
    create unique_index(:research_line, [:research_core_id])
  end
end
