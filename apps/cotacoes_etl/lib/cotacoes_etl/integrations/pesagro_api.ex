defmodule CotacoesETL.Integrations.PesagroAPI do
  alias CotacoesETL.Integrations.IManagePesagroIntegration
  alias CotacoesETL.Schemas.BoletimEntry

  @behaviour IManagePesagroIntegration

  @filetypes ~w(application/pdf application/zip)
  @path "/node/194"

  def base_url, do: "https://www.pesagro.rj.gov.br"

  @impl true
  def fetch_document! do
    raw_document = Tesla.get!(base_url() <> @path).body

    Floki.parse_document!(raw_document)
  end

  @impl true
  def download_file!(link) do
    Tesla.get!(link).body
  end

  @spec fetch_all_links(Floki.html_tree()) :: list(BoletimEntry.t())
  def fetch_all_links(document) do
    document
    |> Floki.find("a")
    |> Enum.filter(&is_pdf_or_zip_link?/1)
    |> Enum.map(fn tag ->
      href = tag |> Floki.attribute("href") |> Floki.text()
      Path.join(base_url(), href)
    end)
  end

  defp is_pdf_or_zip_link?(tag) do
    type = tag |> Floki.attribute("type") |> Floki.text()
    type in @filetypes
  end
end
