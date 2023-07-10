defmodule CotacoesETL.Handlers.IManagePesagroHandler do
  alias Cotacoes.Models.Cotacao
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  @callback is_zip_file?(BoletimEntry.t()) :: boolean
  @callback download_boletim_from_pesagro!(Path.t(), Cotacao.t()) :: Path.t()
  @callback extract_boletins_zip!(Path.t(), Path.t()) :: Path.t()
end
