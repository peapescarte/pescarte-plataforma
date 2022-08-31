defmodule Fuschia.Repo.Migrations.CreateCity do
  use Ecto.Migration

  def change do
    create table(:city) do
      add :county, :string, null: false
      add :public_id, :string, null: false

      timestamps()
    end
  end
end
