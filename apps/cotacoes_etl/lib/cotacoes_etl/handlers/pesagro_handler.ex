defmodule CotacoesETL.Handlers.PesagroHandler do
  import CotacoesETL.Integrations

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Handlers.IManagePesagroHandler

  require Logger

  @behaviour IManagePesagroHandler

  @impl true
  def is_zip_file?(boletim), do: String.ends_with?(boletim.link, "zip")

  @impl true
  def download_boletim_from_pesagro!(storage_path, cotacao) do
    content = pesagro_api().download_file!(cotacao.link)
    base_name = CotacaoHandler.get_cotacao_file_base_name(cotacao)
    file_path = storage_path <> base_name
    File.write!(file_path, content)
    {:ok, _cotacao} = CotacaoHandler.set_cotacao_downloaded(cotacao)

    file_path
  end

  @impl true
  def extract_boletins_zip!(zip_path, storage_path) do
    {:ok, unzip} =
      zip_path
      |> Unzip.LocalFile.open()
      |> Unzip.new()

    for entry <- Unzip.list_entries(unzip) do
      path = storage_path <> entry.file_name
      Logger.info("[#{__MODULE__}] => Extraindo arquivo #{path}")

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
