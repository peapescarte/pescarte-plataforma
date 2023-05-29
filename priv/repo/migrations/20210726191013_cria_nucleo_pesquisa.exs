defmodule Pescarte.Repo.Migrations.CriaNucleoPesquisa do
  use Ecto.Migration

  def change do
    create table(:nucleo_pesquisa) do
      add :nome, :string, null: false
      add :desc, :string, size: 400
      add :letra, :string, null: true
      add :id_publico, :string, null: false

      timestamps()
    end
  end
end
