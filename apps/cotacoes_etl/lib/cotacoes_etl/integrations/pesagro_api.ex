defmodule CotacoesETL.Integrations.PesagroAPI do
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  @filetypes ~w(application/pdf application/zip)

  def base_url, do: "https://www.pesagro.rj.gov.br/node/194"

  @spec fetch_document! :: Floki.html_tree()
  def fetch_document! do
    raw_document = Req.get!(base_url()).body

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
    attrs = %{arquivo: arquivo, link: link}

    BoletimEntry.changeset(attrs)
  end

  defp is_pdf_or_zip?(tag) do
    type = tag |> Floki.attribute("type") |> Floki.text()
    type in @filetypes
  end
end
