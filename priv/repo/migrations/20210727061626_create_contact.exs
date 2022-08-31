defmodule Fuschia.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:contact) do
      add :email, :citext
      add :mobile, :string, max: 14
      add :address, :string

      timestamps()
    end

    create unique_index(:contact, [:email])
  end
end
