defmodule Pescarte.Database.Repo.Migrations.RemoveResponsavelLinhapesquisa do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      remove :responsavel_lp_id
    end
  end
end
