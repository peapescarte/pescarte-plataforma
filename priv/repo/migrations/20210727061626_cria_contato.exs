defmodule Pescarte.Repo.Migrations.CriaContato do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:contato) do
      add :email_principal, :citext
      add :celular_principal, :string, max: 14
      add :emails_adicionais, {:array, :string}
      add :celulares_adicionais, {:array, :string}

      add :endereco_id, references(:endereco)

      timestamps()
    end

    create unique_index(:contato, [:email_principal])
    create unique_index(:contato, [:celular_principal])
  end
end
