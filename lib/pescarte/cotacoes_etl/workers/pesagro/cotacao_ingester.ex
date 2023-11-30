defmodule Pescarte.CotacoesETL.Workers.Pesagro.CotacaoIngester do
  @moduledoc """
  Este worker é responsável por importar as informações de cada
  cotação de cada pescado encontrado nos boletins da Pesagro.
  """

  use GenServer

  alias Pescarte.Cotacoes.Handlers.CotacaoPescadoHandler
  alias Pescarte.Cotacoes.Handlers.FonteHandler
  alias Pescarte.Cotacoes.Handlers.PescadoHandler
  alias Pescarte.CotacoesETL.Events.IngestCotacaoEvent
  alias Pescarte.CotacoesETL.Parsers

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:ingest, %IngestCotacaoEvent{} = event}, state) do
    file_content = File.read!(event.file_path)

    Logger.info("[#{__MODULE__}] ==> Importando cotação #{event.cotacao.link}")

    for row <- Parsers.Pesagro.run(file_content) do
      with {:ok, fonte} <- FonteHandler.fetch_fonte_pesagro(),
           {:ok, pescado} <- PescadoHandler.fetch_or_insert_pescado(row[:pescado_codigo]) do
        CotacaoPescadoHandler.insert_cotacao_pescado(event.cotacao, pescado, fonte, row)
      end
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    GenServer.cast(__MODULE__, msg)
    {:noreply, state}
  end
end
