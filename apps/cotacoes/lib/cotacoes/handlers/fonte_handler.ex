defmodule Cotacoes.Handlers.FonteHandler do
  alias Cotacoes.Handlers.IManageFonteHandler
  alias Cotacoes.Repository

  @behaviour IManageFonteHandler

  @impl true
  def insert_fonte_pesagro(link) do
    attrs = %{
      nome: "pesagro",
      link: link,
      descricao: "Empresa de Pesquisa Agropecuária do Estado do Rio de Janeiro"
    }

    Repository.insert_fonte_cotacao(attrs)
  end

  @impl true
  def fetch_fonte_pesagro do
    Repository.fetch_fonte_by_nome("pesagro")
  end
end
