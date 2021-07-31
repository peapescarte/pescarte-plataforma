defmodule Fuschia.Repo.Migrations.CreateContato do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:contato) do
      add :email, :citext
      add :celular, :string, max: 14
      add :endereco, :string

      timestamps()
    end

    create unique_index(:contato, [:email])
  end
end
