defmodule CotacoesETL.Workers.Pesagro.BoletimIngester do
  # TODO
  @moduledoc """

  """

  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def ingest_cotacoes_pescados_boletim_file(file_path) do
    GenServer.cast(__MODULE__, {:ingest_file, file_path})
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:ingest_file, _file_path}, state) do
    # TODO
    {:noreply, state}
  end
end
