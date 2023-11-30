defmodule Database.Repo.Migrations.CriaPescado do
  use Ecto.Migration

  def change do
    create table(:pescado, primary_key: false) do
      add :id, :string
      add :codigo, :string, primary_key: true, null: false
      add :descricao, :string
      add :embalagem, :string
    end

    create unique_index(:pescado, [:codigo])
  end
end
