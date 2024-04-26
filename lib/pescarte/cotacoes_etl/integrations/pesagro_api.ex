defmodule Pescarte.CotacoesETL.Integrations.PesagroAPI do
  alias Pescarte.CotacoesETL.Integrations.IManagePesagroIntegration
  alias Pescarte.CotacoesETL.Schemas.BoletimEntry

  @path "/node/194"
  @base_url "https://www.rj.gov.br/pesagro"

  @behaviour IManagePesagroIntegration

  @filetypes ~w(application/pdf application/zip)

  defp client do
    Tesla.client([{Tesla.Middleware.BaseUrl, @base_url}])
  end

  @impl true
  def fetch_document! do
    raw_document = Tesla.get!(client(), @path).body
    Floki.parse_document!(raw_document)
  end

  @impl true
  def download_file!(link) do
    Tesla.get!(client(), link).body
  end

  @spec fetch_all_links(Floki.html_tree()) :: list(BoletimEntry.t())
  def fetch_all_links(document) do
    document
    |> Floki.find("a")
    |> Enum.filter(&pdf_or_zip_link?/1)
    |> Enum.map(fn tag ->
      href = tag |> Floki.attribute("href") |> Floki.text()
      Path.join(@base_url, href)
    end)
  end

  defp pdf_or_zip_link?(tag) do
    type = tag |> Floki.attribute("type") |> Floki.text()
    type in @filetypes
  end
end
