defmodule Fuschia.Repo.Migrations.CreateNucleos do
  use Ecto.Migration

  def change do
    create table(:nucleo, primary_key: false) do
      add :nome, :string, primary_key: true
      add :descricao, :string, size: 400, null: false

      timestamps()
    end
  end
end
