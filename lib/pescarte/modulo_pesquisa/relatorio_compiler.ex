defmodule Pescarte.RelatorioCompiler do
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.RelatorioHTML

  def compilar_relatorios(relatorios_selecionados, continuation) do
    with {:ok, htmls} <- parse_relatorios_html(relatorios_selecionados) do
      ChromicPDF.print_to_pdf(htmls,
        output: fn tmp_path ->
          with {:ok, zip_path} <- criar_zip_file(tmp_path) do
            continuation.(zip_path)
          end
        end
      )
    end
  end

  defp parse_relatorios_html(relatorios_ids) do
    result =
      Enum.reduce_while(relatorios_ids, [], fn relatorio_id, htmls ->
        case Repository.fetch_relatorio_pesquisa_by_id(relatorio_id) do
          {:ok, relatorio} ->
            html = RelatorioHTML.content(relatorio)
            {:cont, [{:html, html} | htmls]}

          {:error, :not_found} ->
            {:halt, {:error, :relatorio_not_found}}
        end
      end)

    if err = Enum.find(result, &match?({:error, _}, &1)) do
      {:error, err}
    else
      {:ok, result}
    end
  end

  def gerar_pdf(relatorio_id) do
    with {:ok, relatorio} <- Repository.fetch_relatorio_pesquisa_by_id(relatorio_id),
         {:ok, pdf} <-
           [content: RelatorioHTML.content(relatorio), size: :a4]
           |> ChromicPDF.Template.source_and_options()
           |> ChromicPDF.print_to_pdf(),
         {:ok, binary} <- Base.decode64(pdf) do
      {:ok, "relatorio_#{relatorio.tipo}_#{to_string(relatorio.inserted_at)}.pdf", binary}
    end
  end

  @zip_filename "relatorio_final.zip"
  @zip_filepath ~c"/tmp/#{@zip_filename}"

  defp criar_zip_file(pdf_path) do
    base_name = Path.basename(pdf_path)
    root_path = String.to_charlist(Path.dirname(pdf_path))
    files = [String.to_charlist(base_name)]
    :zip.create(@zip_filepath, files, cwd: root_path)
  end
end
