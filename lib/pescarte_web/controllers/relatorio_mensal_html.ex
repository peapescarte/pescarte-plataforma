defmodule PescarteWeb.RelatorioMensalHTML do
  use PescarteWeb, :html

  embed_templates "relatorio_mensal_html/*"

  @today Date.utc_today()

  def header(assigns) do
    ~H"""
    <div class="flex justify-between items-center w-4/6">
      <h1 class="text-white uppercase font-semibold text-3xl text-center">
        Relatório Mensal de Pesquisa de <%= @today.month %> de <%= @today.year %>
      </h1>
      <!-- FIXME BOTÃO DE SALVAR -->
    </div>
    """
  end
end
