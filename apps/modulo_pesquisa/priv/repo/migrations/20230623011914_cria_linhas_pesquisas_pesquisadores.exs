defmodule ModuloPesquisa.Repo.Migrations.CriaLinhasPesquisasPesquisadores do
  use Ecto.Migration

  def change do
    create table(:linhas_pesquisas_pesquisadores, primary_key: false) do
      add :pesquisador_id, references(:pesquisador, column: :id_publico, type: :string)
      add :linha_pesquisa_numero, references(:linha_pesquisa, column: :numero, type: :integer)
    end
  end
end
