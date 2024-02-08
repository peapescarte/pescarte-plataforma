defmodule Pescarte.RelatorioCompiler do

  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.RelatorioHTML

  def compilar_relatorios(relatorios_selecionados) do
    relatorios = Enum.map(relatorios_selecionados, &find_relatorio/1)
    htmls = Enum.map(relatorios, &RelatorioHTML.content/1)
    pdfs = Enum.reduce(htmls, [], fn html, acc -> [{:html, html} | acc] end)
    {:ok, pdf_compilado} = ChromicPDF.print_to_pdf(pdfs)
    zip_file = criar_zip_file(pdf_compilado)
    elem(zip_file, 1)
  end

  def gerar_pdf(relatorio) do
    {:ok, pdf} =
      [content: RelatorioHTML.content(relatorio), size: :a4]
      |> ChromicPDF.Template.source_and_options()
      |> ChromicPDF.print_to_pdf()

    Base.decode64!(pdf)
  end

  def find_relatorio(relatorio_id) do
    relatorio = Repository.fetch_relatorio_pesquisa_by_id(relatorio_id)
  end

  defp criar_zip_file(pdf) do
    {:ok, zip_file} =
      :zip.create(
        "relatorios_compilados.zip",
        [{~c"relatorios_compilados.pdf", Base.decode64!(pdf)}],
        [:memory]
      )

    zip_file
  end

end
