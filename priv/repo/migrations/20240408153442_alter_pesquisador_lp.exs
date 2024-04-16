defmodule Pescarte.Database.Repo.Migrations.AlterPesquisadorLp do
  use Ecto.Migration

  def change do
    alter table(:pesquisador) do
      add :linha_pesquisa_principal_id, references(:linha_pesquisa, type: :string)
    end

    create index(:pesquisador, [:linha_pesquisa_principal_id])

    alter table(:pesquisador_lp) do
      add :lider?, :boolean, default: false
    end
  end
end
