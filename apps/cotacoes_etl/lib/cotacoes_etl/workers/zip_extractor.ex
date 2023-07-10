defmodule CotacoesETL.Workers.ZIPExtractor do
  @moduledoc """
  Este worker é responsável por extrair arquivos ZIP.
  Assim que todos os arquivos dentro do ZIP forem extraídos,
  uma mensagem para o PID que iniciou esse worker será enviada,
  avisando que o arquivo ZIP foi extraído com sucesso.
  """

  use GenServer

  import CotacoesETL.Handlers, only: [pesagro_handler: 0]

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def extract_zip_to_path(file_path, dest_path, caller) do
    GenServer.cast(__MODULE__, {:extract, file_path, dest_path, caller})
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:extract, zip_file, dest_path, caller}, state) do
    entries = pesagro_handler().extract_boletins_zip!(zip_file, dest_path)
    Logger.info("[#{__MODULE__}] ==> #{length(entries)} arquivos extraídos de ZIP #{zip_file}")
    Process.send(caller, {:zip_extracted, entries}, [])
    {:noreply, state}
  end
end
