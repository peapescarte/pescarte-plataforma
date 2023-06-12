defmodule Pescarte.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa) do
      add :id_publico, :string
      add :numero, :integer, null: false
      add :desc_curta, :string, size: 90, null: false
      add :desc, :string, size: 280

      add :nucleo_pesquisa_id, references(:nucleo_pesquisa), null: false

      timestamps()
    end

    create unique_index(:linha_pesquisa, [:numero])
    create unique_index(:linha_pesquisa, [:nucleo_pesquisa_id])
  end
end
