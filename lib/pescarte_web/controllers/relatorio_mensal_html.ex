defmodule PescarteWeb.RelatorioMensalHTML do
  use PescarteWeb, :html

  embed_templates "relatorio_mensal_html/*"

  @today Date.utc_today()

  defp get_current_month do
    @today.month
  end

  defp get_current_year do
    @today.year
  end

  def header(assigns) do
    ~H"""
    <div class="flex justify-between items-center w-4/6">
      <h1 class="text-white uppercase font-semibold text-3xl text-center">
        Relatório Mensal de Pesquisa de <%= get_current_month() %> de <%= get_current_year() %>
      </h1>

    </div>
    """
  end
end
