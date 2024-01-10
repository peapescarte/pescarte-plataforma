defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  @moduledoc false

  use Phoenix.LiveView
  use PlataformaDigital, :auth_live_view

  alias ModuloPesquisa.Handlers.RelatoriosHandler

  @impl true
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
  },
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
  },
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


{:ok,
 socket
 |> assign(relatorios: list)
 |> assign(tipo_relatorio: "")}

  end

  @impl true
  # vou comentar para mostrar o dropdown, em 10/1/2024:
#  def handle_event("preencher-relatorio", %{"value" => tipo_relatorio}, socket) do
#    {:noreply, push_redirect(socket, to: ~p"/app/pesquisa/relatorios/new?tipo=#{tipo_relatorio}")}
#  end

  # inserido em 10/1/2024 para apresentação da Petrobras:
  def handle_event("toggleDropdown", _, socket) do
    {:noreply, socket}
  end

  attr :label, :string, required: true
  attr :click, :string, required: true

  slot :inner_block
  
  def report_menu_link(assigns) do
    ~H"""
    <div class="profile-menu-link">
      <span class="flex items-center justify-center bg-white-100">
        <%= render_slot(@inner_block) %>
      </span>
      <.button style="link" class="whitespace-nowrap" click={@click} phx-target=".profile-menu-link">
        <.text size="base" color="text-blue-80" class="bg-white-100">
          <%= @label %>
        </.text>
      </.button>
    </div>
    """
  end

  @impl true
  def handle_event("mensal_report", _, socket) do
    {:noreply, Phoenix.LiveView.redirect(socket, to: ~p"/app/pesquisa/pesquisadores")}
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
