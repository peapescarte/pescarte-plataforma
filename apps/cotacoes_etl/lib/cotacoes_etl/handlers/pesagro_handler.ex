defmodule CotacoesETL.Handlers.PesagroHandler do
  import CotacoesETL.Integrations

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Handlers.IManagePesagroHandler

  @behaviour IManagePesagroHandler

  @impl true
  def download_cotacao_from_pesagro!(storage_path, cotacao) do
    content = pesagro_api().download_file!(cotacao.link)
    base_name = CotacaoHandler.get_cotacao_file_base_name(cotacao)
    file_path = Path.join(storage_path, base_name)
    File.write!(file_path, content)
    {:ok, cotacao} = CotacaoHandler.set_cotacao_downloaded(cotacao)

    {cotacao, file_path}
  end
end
