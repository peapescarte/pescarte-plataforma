defmodule ModuloPesquisa.Repo.Migrations.CreateRelatorioMensalPesquisa do
  use Ecto.Migration

  def change do
    create table(:relatorio_mensal_pesquisa, primary_key: false) do
      # Primeira seção
      add :acao_planejamento, :text
      add :participacao_grupos_estudo, :text
      add :acoes_pesquisa, :text
      add :participacao_treinamentos, :text
      add :publicacao, :text

      # Segunda seção
      add :previsao_acao_planejamento, :text
      add :previsao_participacao_grupos_estudo, :text
      add :previsao_participacao_treinamentos, :text
      add :previsao_acoes_pesquisa, :text

      add :data_entrega, :date
      add :ano, :smallint, null: false, primary_key: true
      add :mes, :smallint, null: false, primary_key: true
      add :link, :string
      add :status, :string, null: false
      add :id_publico, :string

      add :pesquisador_id, references(:pesquisador, column: :id_publico, type: :string),
        null: false

      timestamps()
    end

    create unique_index(:relatorio_mensal_pesquisa, [:ano, :mes])
    create index(:relatorio_mensal_pesquisa, [:pesquisador_id])
  end
end
