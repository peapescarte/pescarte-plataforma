defmodule Pescarte.Database.Repo.Migrations.AtualizarLenDescNucleopesquisa do
  use Ecto.Migration

  def change do
    alter table(:nucleo_pesquisa) do
      modify :desc, :text
    end
  end
end
