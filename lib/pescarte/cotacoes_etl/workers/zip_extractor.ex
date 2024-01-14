defmodule Pescarte.CotacoesETL.Workers.ZIPExtractor do
  @moduledoc """
  Este worker é responsável por extrair arquivos ZIP.
  Assim que todos os arquivos dentro do ZIP forem extraídos,
  uma mensagem para o PID que iniciou esse worker será enviada,
  avisando que o arquivo ZIP foi extraído com sucesso.
  """

  use GenServer

  import Pescarte.CotacoesETL.Handlers, only: [zip_extractor_handler: 0]

  alias Pescarte.CotacoesETL.Events.ExtractZIPEvent

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:extract, %ExtractZIPEvent{} = event}, state) do
    unless File.exists?(event.destination_path) do
      File.mkdir_p!(event.destination_path)
    end

    entries = zip_extractor_handler().extract_zip_to!(event.zip_path, event.destination_path)

    Logger.info(
      "[#{__MODULE__}] ==> #{length(entries)} arquivos extraídos de ZIP #{event.zip_path}"
    )

    Process.send(event.issuer, {:zip_extracted, entries}, [])

    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    GenServer.cast(__MODULE__, msg)
    {:noreply, state}
  end
end
