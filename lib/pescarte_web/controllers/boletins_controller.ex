defmodule PescarteWeb.BoletinsController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    pdf_urls = get_public_document_url()

    render(conn, :show, current_path: conn.request_path, pdf_url: pdf_urls, error_message: nil)
  end

  defp get_public_document_url do
    pdf_paths =
      for i <- 1..8, do: "publicacoes/boletins/boletim%20#{i}/Boletim%20Pescarte%200#{i}.pdf"

    pdf_paths
    |> Enum.with_index(1)
    |> Enum.map(fn {link, index} ->
      case Pescarte.Storage.get_public_area_image_url(link, 36_000, transform: nil) do
        {:ok, url} -> {"boletim#{index}", url}
        _ -> {"boletim#{index}", nil}
      end
    end)
    |> Enum.into(%{})
  end
end
