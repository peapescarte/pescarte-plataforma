defmodule Pescarte.Database.Repo.Migrations.AtualizarNucleoNullLinhapesquisa do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      modify :nucleo_pesquisa_letra,
             references(:nucleo_pesquisa, column: :letra, type: :string),
             null: true,
             from: references(:linha_pesquisa, null: false)

    end
  end
end
