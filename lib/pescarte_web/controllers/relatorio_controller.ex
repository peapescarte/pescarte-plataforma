defmodule PescarteWeb.Pesquisa.RelatorioController do
  use PescarteWeb, :controller

  alias Pescarte.RelatorioCompiler

  def download_pdf(conn, %{"id" => id}) do
    relatorio = RelatorioCompiler.find_relatorio(id)
    pdf_binary = RelatorioCompiler.gerar_pdf(relatorio)
    enviar_pdf_response(conn, id, pdf_binary)
  end

  def compilar_relatorios(conn, params) do
    campos_formularios = Map.keys(params)
    relatorios_selecionados = Enum.filter(campos_formularios, fn id -> id != "_csrf_token" end)
    zip_file = RelatorioCompiler.compilar_relatorios(relatorios_selecionados)
    enviar_zip_response(conn, zip_file)
  end

  defp enviar_pdf_response(conn, id, pdf_file) do
    send_download(
      conn,
      {:binary, pdf_file},
      content_type: "application/pdf",
      filename: "relatorios-#{id}.pdf"
    )
  end

  def enviar_zip_response(conn, zip_file) do
    send_download(
      conn,
      {:binary, zip_file},
      content_type: "application/zip",
      filename: "relatorios-compilados.zip"
    )
  end
end
