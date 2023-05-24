defmodule Pescarte.Repo.Migrations.CriaEndereco do
  use Ecto.Migration

  def change do
    create table(:endereco) do
      add :rua, :string
      add :numero, :smallint
      add :complemento, :string
      add :cep, :string
      add :cidade, :string
      add :estado, :string
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
