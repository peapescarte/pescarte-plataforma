defmodule Pescarte.Repo.Migrations.CreatePesquisadorLp do
  use Ecto.Migration

  def change do
    create table(:pesquisador_lp, primary_key: false) do
      add :pesquisador, :string, primary_key: true
      add :linha_pesquisa, :string, primary_key: true
      add :lider?, :boolean, default: false

      timestamps()
    end
    create(index(:pesquisador_lp, [:pesquisador]))
    create(index(:pesquisador_lp, [:linha_pesquisa]))
  end
end
