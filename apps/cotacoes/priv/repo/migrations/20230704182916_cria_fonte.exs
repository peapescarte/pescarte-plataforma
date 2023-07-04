defmodule Database.Repo.Migrations.CriaFonte do
  use Ecto.Migration

  def change do
    create table(:fonte, primary_key: false) do
      add :id, :string
      add :nome, :string, primary_key: true, null: false
      add :descricao, :string
      add :link, :string, null: false
    end

    create unique_index(:fonte, [:nome, :link])
  end
end
