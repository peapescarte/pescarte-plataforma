defmodule CotacoesETL.Integrations.PesagroAPI do
  alias CotacoesETL.Integrations.IManagePesagroIntegration
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  @behaviour IManagePesagroIntegration

  @filetypes ~w(application/pdf application/zip)
  @path "/node/194"

  def base_url, do: "https://www.pesagro.rj.gov.br"

  @impl true
  def fetch_document! do
    raw_document = Tesla.get!(base_url() <> @path).body

    Floki.parse_document!(raw_document)
  end

  @spec fetch_all_boletim_links(Floki.html_tree()) :: list(BoletimEntry.t())
  def fetch_all_boletim_links(document) do
    document
    |> Floki.find("a")
    |> Enum.filter(&is_pdf_or_zip?/1)
    |> Enum.map(&a_tag_to_boletim/1)
  end

  defp a_tag_to_boletim(tag) do
    arquivo = Floki.text(Floki.attribute(tag, "title"))
    link = base_url() <> Floki.text(Floki.attribute(tag, "href"))
    type = tag |> Floki.attribute("type") |> Floki.text()
    tipo = if type == "application/pdf", do: :pdf, else: :zip
    attrs = %{arquivo: arquivo, link: link, tipo: tipo}

    BoletimEntry.changeset(attrs)
  end

  defp is_pdf_or_zip?(tag) do
    type = tag |> Floki.attribute("type") |> Floki.text()
    type in @filetypes
  end
end
