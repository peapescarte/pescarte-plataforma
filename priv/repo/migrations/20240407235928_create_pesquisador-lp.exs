defmodule Elixir.Pescarte.Database.Repo.Migrations.CreatePesquisadorLp do
  use Ecto.Migration

  def change do
    create table(:pesquisador_lp) do
      add :pesquisador_id, references(:pesquisador, type: :string), null: false
      add :linha_pesquisa_id, references(:linha_pesquisa, type: :string), null: false
    end

    create index(:pesquisador_lp, [:pesquisador_id])
    create index(:pesquisador_lp, [:linha_pesquisa_id])
  end
end
