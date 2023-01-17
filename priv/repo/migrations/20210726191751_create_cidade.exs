defmodule Pescarte.Repo.Migrations.CreateCidade do
  use Ecto.Migration

  def change do
    create table(:cidade) do
      add :county, :string, null: false
      add :public_id, :string, null: false

      timestamps()
    end
  end
end
