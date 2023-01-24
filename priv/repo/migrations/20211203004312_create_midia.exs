defmodule Pescarte.Repo.Migrations.CreateMidia do
  use Ecto.Migration

  def change do
    create table("midia") do
      add :public_id, :string
      add :type, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false
      add :pesquisador_id, references(:pesquisador), null: false

      timestamps()
    end

    create unique_index(:midia, [:link])
    create index(:midia, [:pesquisador_id])
  end
end
