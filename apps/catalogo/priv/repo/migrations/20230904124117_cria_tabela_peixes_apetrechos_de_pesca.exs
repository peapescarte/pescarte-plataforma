defmodule Catalogo.Repo.Migrations.CriaTabelaPeixesApetrechosDePesca do
  use Ecto.Migration

  def change do
    create table(:peixes_apetrechos_pesca, primary_key: false) do
      add :peixe_nome_cientifico, references(:peixe, column: :nome_cientifico, type: :string), primary_key: true
      add :apetrecho_nome, references(:apetrecho_pesca, column: :nome, type: :string), primary_key: true

      timestamps()
    end
  end
end
