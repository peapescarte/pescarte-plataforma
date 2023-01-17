defmodule Pescarte.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa) do
      add :public_id, :string
      add :number, :integer, null: false
      add :short_desc, :string, size: 90, null: false
      add :desc, :string, size: 280
      add :nucleo_pesquisa_id, references(:nucleo_pesquisa), null: false

      timestamps()
    end

    create unique_index(:linha_pesquisa, [:number])
    create unique_index(:linha_pesquisa, [:nucleo_pesquisa_id])
  end
end
