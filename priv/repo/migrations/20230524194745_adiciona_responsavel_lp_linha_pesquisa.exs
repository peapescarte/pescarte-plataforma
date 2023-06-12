defmodule Pescarte.Repo.Migrations.AdicionaResponsavelLpLinhaPesquisa do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      add :responsavel_lp_id, references(:pesquisador), null: false
    end

    create index(:linha_pesquisa, [:responsavel_lp_id])
  end
end
