defmodule PescarteWeb.Pesquisa.Relatorio.ListReportLive do
  use PescarteWeb, :auth_live_view

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
  def handle_event("preencher-relatorio", %{"value" => tipo_relatorio}, socket) do
    {:noreply, push_redirect(socket, to: ~p"/app/pesquisa/relatorios/new?tipo=#{tipo_relatorio}")}
  end
end
