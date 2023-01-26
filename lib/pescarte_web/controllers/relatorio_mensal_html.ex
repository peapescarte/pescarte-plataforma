defmodule PescarteWeb.RelatorioMensalHTML do
  use PescarteWeb, :html

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  embed_templates "relatorio_mensal_html/*"

  @today Date.utc_today()

  @full_month %{
    "1" => "Janeiro",
    "2" => "Fevereiro",
    "3" => "Março",
    "4" => "Abril",
    "5" => "Maio",
    "6" => "Junho",
    "7" => "Julho",
    "8" => "Agosto",
    "9" => "Setembro",
    "10" => "Outubro",
    "11" => "Novembro",
    "12" => "Dezembro"
  }

  # Pega apenas os campos que devem ser preenchidos no formulário
  defp form_fields do
    :fields
    |> RelatorioMensal.__schema__()
    |> Enum.split(-7)
    |> then(fn {[_ | fields], _} -> fields end)
  end

  defp now_month do
    @today.month
    |> Integer.to_string()
    |> then(&Map.get(@full_month, &1))
  end

  defp now_year do
    @today.year
  end
end
