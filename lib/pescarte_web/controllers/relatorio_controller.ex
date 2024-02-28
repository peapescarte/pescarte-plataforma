defmodule PescarteWeb.Pesquisa.RelatorioController do
  use PescarteWeb, :controller

  alias Pescarte.RelatorioCompiler

  def download_pdf(conn, %{"id" => id}) do
    with {:ok, pdf_filename, pdf_binary} <- RelatorioCompiler.gerar_pdf(id) do
      conn
      |> put_status(:ok)
      |> send_download({:binary, pdf_binary}, filename: pdf_filename)
    end
  end

  def compilar_relatorios(conn, params) do
    campos_formularios = Map.delete(params, "_csrf_token")
    relatorios_selecionados = Map.keys(campos_formularios)

    RelatorioCompiler.compilar_relatorios(relatorios_selecionados, fn zip_name, zip_content ->
      conn
      |> put_status(:ok)
      |> send_download({:binary, zip_content}, filename: zip_name)
    end)
  end
end
