defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  @moduledoc false

#  use Phoenix.LiveView
  use PlataformaDigital, :auth_live_view

#  alias ModuloPesquisa.Handlers.RelatoriosHandler

#  @impl true
  def mount(_params, _session, socket) do
    list = [
      %{
        data: "4/5/2023",
        tipo: "Mensal",
        name: "Relatório Mensal - Maio",
        ano: "2023",
        mes: "Maio",
        status: "Entregue"
      },
      %{
        data: "4/5/2023",
        tipo: :Anual,
        name: "Relatório Mensal - Junho",
        ano: "2023",
        mes: "Maio",
        status: "Atrasado"
      },
      %{
        data: "4/5/2023",
        tipo: :Mensal,
        name: "Relatório Mensal - Agosto",
        ano: "2023",
        mes: "Maio",
        status: "Atrasado"
      },
      %{
        data: "4/5/2023",
        tipo: :Anual,
        name: "Relatório Mensal - Julho",
        ano: "2023",
        mes: "Maio",
        status: "Entregue"
      }
    ]
    {:ok, assign(socket, relatorios: list, tabela: list)}
  end

  # ================= Vamos trabalhar o dropdown do "Preencher Relatório" 09-14/10/2023
  @impl true
  def handle_event("mensal_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
    # ~p"/app/pesquisa/relatorios"
  end

  def handle_event("trimestral_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end

  def handle_event("bienal_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end

  def handle_event("anual_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
  end
end
