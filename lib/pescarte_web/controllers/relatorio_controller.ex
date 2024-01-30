defmodule PescarteWeb.Pesquisa.RelatorioController do
  use PescarteWeb, :controller

  alias PescarteWeb.RelatorioHTML
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.ModuloPesquisa.Repository

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

  defp fetch_and_preload_relatorio(relatorio_id) do
    Repository.fetch_relatorio_pesquisa_by_id(relatorio_id)
    |> Replica.preload(pesquisador: [:usuario, :linha_pesquisa, :orientador])
  end

  defp gerar_pdf(relatorio) do
    {:ok, pdf} =
      [content: RelatorioHTML.content(relatorio), size: :a4]
      |> ChromicPDF.Template.source_and_options()
      |> ChromicPDF.print_to_pdf()
    Base.decode64!(pdf)
  end
end
