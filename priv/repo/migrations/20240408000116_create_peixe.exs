defmodule Pescarte.Database.Repo.Migrations.CreatePeixe do
  use Ecto.Migration

  def change do
    create table(:peixe, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome_cientifico, :string, null: false
      add :link_imagem, :string
      add :nativo?, :boolean, null: false

      timestamps()
    end
  end
end
