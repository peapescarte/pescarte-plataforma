defmodule PescarteWeb.GeorreferenciamentosController do
  @moduledoc """
  Controller responsável por gerenciar as requisições relacionadas a
  georreferenciamentos.
  """

  use PescarteWeb, :controller

  @doc """
  Exibe a página de georreferenciamentos com links para os PDFs disponíveis.

  ## Parâmetros
    - conn: conexão Phoenix
    - _params: parâmetros da requisição (não utilizados)

  ## Retorno
    Renderiza o template :show com os links para os PDFs
  """
  def show(conn, _params) do
    pdf_urls = get_public_document_url()

    render(conn, :show, current_path: conn.request_path, pdf_url: pdf_urls, error_message: nil)
  end

  defp get_public_document_url do
    pdf_paths =
      for i <- 1..1,
          do:
            "publicacoes/georreferenciamentos/georreferenciamento%20#{i}/Georreferenciamento%200#{i}.pdf"

    pdf_paths
    |> Enum.with_index(1)
    |> Enum.map(fn {link, index} ->
      case Pescarte.Storage.get_public_area_image_url(link, 36_000, transform: nil) do
        {:ok, url} -> {"georreferenciamento#{index}", url}
        _ -> {"boletim#{index}", nil}
      end
    end)
    |> Enum.into(%{})
  end
end
