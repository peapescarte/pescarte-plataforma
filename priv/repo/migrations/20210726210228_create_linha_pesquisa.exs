defmodule Fuschia.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :numero, :integer, null: false
      add :descricao_curta, :string, size: 50, null: false
      add :descricao_longa, :string, size: 280
      add :nucleo_id, references(:nucleo, type: :string), null: false

      timestamps()
    end

    create unique_index(:linha_pesquisa, [:numero])
    create unique_index(:linha_pesquisa, [:nucleo_id])
  end
end
