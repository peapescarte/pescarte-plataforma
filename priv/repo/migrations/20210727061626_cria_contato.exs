defmodule Pescarte.Repo.Migrations.CriaContato do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:contato, primary_key: false) do
      add :email_principal, :citext, primary_key: true, null: false
      add :celular_principal, :string, max: 14
      add :emails_adicionais, {:array, :string}
      add :celulares_adicionais, {:array, :string}
      add :id_publico, :string

      add :endereco_cep, references(:endereco, column: :cep, type: :string)

      timestamps()
    end

    create unique_index(:contato, [:email_principal])
    create unique_index(:contato, [:celular_principal])
    create index(:contato, [:endereco_cep])
  end
end
