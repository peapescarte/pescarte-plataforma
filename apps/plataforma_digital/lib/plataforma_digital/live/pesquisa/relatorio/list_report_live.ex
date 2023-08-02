defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  use PlataformaDigital, :auth_live_view

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
      }
    ]

    {:ok, assign(socket, relatorios: list)}
  end
end
