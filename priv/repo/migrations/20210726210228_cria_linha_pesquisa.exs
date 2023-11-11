defmodule Pescarte.ModuloPesquisa.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa, primary_key: false) do
      add :id_publico, :string
      add :numero, :integer, null: false, primary_key: true
      add :desc_curta, :string, size: 90, null: false
      add :desc, :string, size: 280

      add :nucleo_pesquisa_letra,
          references(:nucleo_pesquisa, column: :letra, type: :string),
          null: false

      timestamps()
    end

    create unique_index(:linha_pesquisa, [:nucleo_pesquisa_letra])
  end
end
