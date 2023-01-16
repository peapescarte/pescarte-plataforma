defmodule Pescarte.Repo.Migrations.CreateNucleoPesquisa do
  use Ecto.Migration

  def change do
    create table(:nucleo_pesquisa) do
      add :name, :string, null: false
      add :desc, :string, size: 400
      add :public_id, :string, null: false

      timestamps()
    end
  end
end
