defmodule Pescarte.Repo.Migrations.CriaLPsPesquisadores do
  use Ecto.Migration

  def change do
    create table(:LPs_pesquisadores) do
      add :linha_pesquisa_id, references(:linha_pesquisa)
      add :pesquisador_id, references(:pesquisador)
    end
  end
end
