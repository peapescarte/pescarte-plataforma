defmodule PescarteWeb.RelatorioHTML do
  use PescarteWeb, :html

  alias Phoenix.HTML.Safe

  import Pescarte.Identidades.Handlers.UsuarioHandler

  embed_templates("relatorio_html/*")

  def content(%{tipo: :mensal} = assigns) do
    relatorio = relatorio_mensal(assigns)

    relatorio
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  def content(%{tipo: :trimestral} = assigns) do
    relatorio = relatorio_trimestral(assigns)

    relatorio
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  def content(%{tipo: :anual} = assigns) do
    relatorio = relatorio_anual(assigns)

    relatorio
    |> Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp get_image_path(filename) do
    priv_dir = :code.priv_dir(:pescarte)
    Path.join([priv_dir, "static/images/relatorio/#{filename}"])
  end

  defp get_literal_mes(data) do
    {:ok, mes} = Timex.lformat(data, "{Mfull}", "pt")
    mes
  end
end
