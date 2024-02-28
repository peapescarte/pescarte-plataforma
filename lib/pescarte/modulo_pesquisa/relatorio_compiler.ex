defmodule Pescarte.RelatorioCompiler do
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.RelatorioHTML

  def compilar_relatorios(relatorios_selecionados, continuation) do
    with {:ok, htmls} <- parse_relatorios_html(relatorios_selecionados) do
      ChromicPDF.print_to_pdf(htmls,
        output: fn tmp_path ->
          with {:ok, zip_filename, zip_file} <- criar_zip_file(tmp_path) do
            continuation.(zip_filename, zip_file)
          end
        end
      )
    end
  end

  defp parse_relatorios_html(relatorios_ids) do
    Enum.reduce_while(relatorios_ids, [], fn relatorio_id, htmls ->
      if relatorio = Repository.fetch_relatorio_pesquisa_by_id(relatorio_id) do
        html = RelatorioHTML.content(relatorio)
        {:cont, [{:html, html} | htmls]}
      else
        {:halt, {:error, :pdf_not_found}}
      end
    end)
  end

  def gerar_pdf(relatorio_id) do
    if relatorio = Repository.fetch_relatorio_pesquisa_by_id(relatorio_id) do
      with {:ok, pdf} <-
             [content: RelatorioHTML.content(relatorio), size: :a4]
             |> ChromicPDF.Template.source_and_options()
             |> ChromicPDF.print_to_pdf() do
        Base.decode64(pdf)
      end
    else
      {:error, :pdf_not_found}
    end
  end

  @zip_filename "relatorio_final.zip"

  defp criar_zip_file(pdf_path) do
    files = [{String.to_charlist(pdf_path)}]

    with {:ok, {_, binary}} <- :zip.create(@zip_filename, files, [:memory]) do
      {:ok, @zip_filename, binary}
    end
  end
end
