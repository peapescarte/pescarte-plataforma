defmodule Pescarte.Database.Repo.Migrations.AtualizarLenDescLinhapesquisa do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      modify :desc, :text
    end
  end
end
