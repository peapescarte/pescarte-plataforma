defmodule PescarteWeb.RelatorioHTML do
  use PescarteWeb, :html

  embed_templates("relatorio_html/*")

  def content(%{tipo: :mensal} = assigns) do
    relatorio_mensal(assigns)
    |> Phoenix.HTML.Safe.to_iodata()
    |> IO.iodata_to_binary()
  end

  defp get_image_path(filename) do
    priv_dir = :code.priv_dir(:pescarte)
    Path.join([priv_dir, "static/images/relatorio/#{filename}"])
  end

  defp get_literal_mes(mes) do
    meses = %{
      1 => "Janeiro",
      2 => "Fevereiro",
      3 => "Março",
      4 => "Abril",
      5 => "Maio",
      6 => "Junho",
      7 => "Julho",
      8 => "Agosto",
      9 => "Setembro",
      10 => "Outubro",
      11 => "Novembro",
      12 => "Dezembro"
    }

    meses[mes]
  end
end
