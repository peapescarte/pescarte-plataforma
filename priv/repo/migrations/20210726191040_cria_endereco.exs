defmodule Identidades.EctoRepo.Migrations.CriaEndereco do
  use Ecto.Migration

  def change do
    create table(:endereco, primary_key: false) do
      add :bairro, :string, null: true
      add :rua, :string, null: true
      add :numero, :string, null: true
      add :complemento, :string, null: true
      add :cep, :string, primary_key: true, null: false
      add :cidade, :string, null: true
      add :estado, :string, null: true
      add :id_publico, :string

      timestamps()
    end

    create unique_index(:endereco, [:cep])
  end
end
