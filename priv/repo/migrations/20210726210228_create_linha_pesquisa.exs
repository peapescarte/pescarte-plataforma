defmodule Fuschia.Repo.Migrations.CreateLinhaPesquisa do
  use Ecto.Migration

  def change do
    create table(:linha_pesquisa) do
      add :numero_linha, :integer, null: false

      add :nucleo_nome, references(:nucleo, column: :nome, type: :string, on_delete: :delete_all),
        null: false

      add :descricao_curta, :string, size: 50, null: false
      add :descricao_longa, :string, size: 280

      timestamps()
    end

    create unique_index(:linha_pesquisa, [:numero_linha, :nucleo_nome],
             name: :numero_linha_nucleo_nome_index
           )
  end
end
