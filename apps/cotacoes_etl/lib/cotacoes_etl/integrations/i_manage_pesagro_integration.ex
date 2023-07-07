defmodule CotacoesETL.Integrations.IManagePesagroIntegration do
  @callback fetch_document! :: Floki.html_tree()
end
