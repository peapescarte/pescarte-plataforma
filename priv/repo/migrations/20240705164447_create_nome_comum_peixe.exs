defmodule Pescarte.Database.Repo.Migrations.CreateNomeComumPeixe do
  use Ecto.Migration

  def change do
    create table(:nome_comum_peixe, primary_key: false) do
      add :nome_comum, :string, primary_key: true
      add :nome_cientifico, :string, primary_key: true
      add :comunidade_nome, :string, primary_key: true
      add :validado?, :boolean, default: false

      timestamps()
    end
  end
end
