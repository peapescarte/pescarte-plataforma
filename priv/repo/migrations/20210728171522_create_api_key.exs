defmodule Fuschia.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_key) do
      add :key, :uuid
      add :description, :string
      add :active, :boolean, default: true

      timestamps()
    end

    create index(:api_key, [:key], unique: true)
  end
end
