defmodule PescarteWeb.Pesquisa.RelatorioController do
  use PescarteWeb, :controller

  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.RelatorioHTML

  def download_pdf(conn, %{"id" => id}) do
    relatorio = fetch_and_preload_relatorio(id)
    pdf_binary = gerar_pdf(relatorio)
    enviar_pdf_response(conn, id, pdf_binary)
  end

  defp enviar_pdf_response(conn, id, pdf_file) do
    conn
    |> put_resp_content_type("application/pdf")
    |> put_resp_header("content-disposition", "attachment; filename=relatorios-#{id}.pdf")
    |> send_resp(200, pdf_file)
  end

  def compilar_relatorios(conn, %{"selected_reports" => relatorios_selecionados}) do
    relatorios = Enum.map(relatorios_selecionados, &fetch_and_preload_relatorio/1)
    htmls = Enum.map(relatorios, &RelatorioHTML.content/1)
    pdfs = Enum.reduce(htmls, [], fn html, acc -> [{:html, html} | acc] end)
    {:ok, pdf_compilado} = ChromicPDF.print_to_pdf(pdfs)
    zip_file = criar_zip_file(pdf_compilado)
    enviar_zip_response(conn, elem(zip_file, 1))
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

  def enviar_zip_response(conn, zip_file) do
    conn
    |> put_resp_content_type("application/zip")
    |> send_resp(200, zip_file)
  end

  defp fetch_and_preload_relatorio(relatorio_id) do
    relatorio = Repository.fetch_relatorio_pesquisa_by_id(relatorio_id)
    Replica.preload(relatorio, pesquisador: [:usuario, :linha_pesquisa, :orientador])
  end

  defp gerar_pdf(relatorio) do
    {:ok, pdf} =
      [content: RelatorioHTML.content(relatorio), size: :a4]
      |> ChromicPDF.Template.source_and_options()
      |> ChromicPDF.print_to_pdf()

    Base.decode64!(pdf)
  end
end
