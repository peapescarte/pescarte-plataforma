defmodule Catalogo.Repo.Migrations.CriaTabelaNomesComounsPeixes do
  use Ecto.Migration

  def change do
    create table(:nomes_comuns_peixe, primary_key: false) do
      add :nome_comum, :string
      add :nome_cientifico, references(:peixe, column: :nome_cientifico, type: :string, on_delete: :nothing), null: false
      add :comunidade_nome, references(:comunidade, column: :nome, type: :string, on_delete: :nothing), null: false
      add :validado?, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:nomes_comuns_peixe, [:nome_comum, :nome_cientifico, :comunidade_nome], name: :nomes_comuns_pk)
  end
end
