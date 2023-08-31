defmodule Catalogo.Repo.Migrations.CriaTabelaPeixesHabitats do
  use Ecto.Migration

  def change do
    create table(:peixes_habitats, primary_key: false) do
      add :peixe_nome_cientifico, references(:peixe, column: :nome_cientifico, type: :string), primary_key: true
      add :habitat_nome, references(:habitat, column: :nome, type: :string), primary_key: true
  end
end
