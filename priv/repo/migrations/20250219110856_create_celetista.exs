defmodule Pescarte.Database.Repo.Migrations.CreateCeletista do
  use Ecto.Migration

  def change do
    create table(:celetista, primary_key: false) do
      add :id, :string, primary_key: true
      add :equipe, :string, null: false
      add :usuario_id, references(:usuario, type: :string), null: false
    end
  end
end
