defmodule Pescarte.Repo.Migrations.CriaNucleoPesquisa do
  use Ecto.Migration

  def change do
    create table(:nucleo_pesquisa, primary_key: false) do
      add :nome, :string, null: false
      add :desc, :string, size: 400
      add :letra, :string, primary_key: true, null: true
      add :id_publico, :string, null: false

      timestamps()
    end

    create unique_index(:nucleo_pesquisa, [:nome, :letra])
  end
end
