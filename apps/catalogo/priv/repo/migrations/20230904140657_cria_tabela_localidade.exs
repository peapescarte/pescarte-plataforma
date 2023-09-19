defmodule Catalogo.Repo.Migrations.CriaTabelaLocalidade do
  use Ecto.Migration

  def change do
    create table(:localidade, primary_key: false) do
      add :nome, :string, primary_key: true
      add :descricao, :text
      add :comunidade_nome, references(:comunidade, column: :nome, type: :string), null: false
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
