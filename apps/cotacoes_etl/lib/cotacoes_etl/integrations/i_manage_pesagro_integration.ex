defmodule CotacoesETL.Integrations.IManagePesagroIntegration do
  @callback fetch_document! :: Floki.html_tree()
  @callback download_file!(link) :: binary
            when link: String.t()
end
