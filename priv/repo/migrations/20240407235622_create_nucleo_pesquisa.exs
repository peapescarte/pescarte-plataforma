defmodule Pescarte.Database.Repo.Migrations.CreateNucleoPesquisa do
  use Ecto.Migration

  def change do
    create table(:nucleo_pesquisa, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string
      add :letra, :string
      add :desc, :text

      timestamps()
    end
  end
end
