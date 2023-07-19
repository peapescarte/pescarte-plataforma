defmodule CotacoesETL.Logic.PesagroLogic do
  alias Cotacoes.Handlers.CotacaoHandler

  def fetch_cotacao_by_file_path(file_path, storage_path) do
    [cotacao_id, _file] =
      file_path
      |> String.replace(storage_path, "")
      |> String.split("/")

    CotacaoHandler.fetch_cotacao_by_id(cotacao_id)
  end
end
