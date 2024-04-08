defmodule Pescarte.Database.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa, primary_key: false) do
      add :id, :string, primary_key: true
      add :numero, :integer
      add :desc_curta, :string
      add :desc, :text
      add :nucleo_pesquisa_id, references(:nucleo_pesquisa, type: :string), null: false

      timestamps()
    end

    create index(:linha_pesquisa, [:nucleo_pesquisa_id])
  end
end
