defmodule Pescarte.CotacoesETL.Handlers.ZIPExtractorHandler do
  alias Pescarte.CotacoesETL.Handlers.IManageZIPExtractorHandler
  alias Pescarte.CotacoesETL.Workers.ZIPExtractor

  @behaviour IManageZIPExtractorHandler

  @impl true
  def trigger_extract_zip_to_path(file_path, dest_path, caller) do
    GenServer.cast(ZIPExtractor, {:extract, file_path, dest_path, caller})
  end

  @impl true
  def extract_zip_to!(zip_path, storage_path) do
    {:ok, unzip} =
      zip_path
      |> Unzip.LocalFile.open()
      |> Unzip.new()

    for entry <- Unzip.list_entries(unzip) do
      path = Path.join(storage_path, entry.file_name)

      file_binary =
        unzip
        |> Unzip.file_stream!(entry.file_name)
        |> Enum.into([])
        |> IO.iodata_to_binary()

      :ok = File.write(path, file_binary)

      path
    end
  end
end
