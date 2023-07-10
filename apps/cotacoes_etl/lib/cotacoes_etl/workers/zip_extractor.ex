defmodule CotacoesETL.Workers.ZIPExtractor do
  @moduledoc """
  Este worker é responsável por extrair arquivos ZIP.
  Assim que todos os arquivos dentro do ZIP forem extraídos,
  uma mensagem para o PID que iniciou esse worker será enviada,
  avisando que o arquivo ZIP foi extraído com sucesso.
  """

  use GenServer

  import CotacoesETL.Handlers, only: [zip_extractor_handler: 0]

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:extract, zip_file, dest_path, caller}, state) do
    IO.inspect(zip_extractor_handler())
    entries = zip_extractor_handler().extract_zip_to!(zip_file, dest_path)
    Logger.info("[#{__MODULE__}] ==> #{length(entries)} arquivos extraídos de ZIP #{zip_file}")
    Process.send(caller, {:zip_extracted, entries}, [])
    {:noreply, state}
  end
end
