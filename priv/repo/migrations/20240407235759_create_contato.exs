defmodule Pescarte.Database.Repo.Migrations.CreateContato do
  use Ecto.Migration

  def change do
    create table(:contato, primary_key: false) do
      add :id, :string, primary_key: true
      add :email_principal, :string, null: false
      add :emails_adicionais, {:array, :string}
      add :celular_principal, :string, null: false
      add :celulares_adicionais, {:array, :string}
      add :endereco, :string

      timestamps()
    end
  end
end
