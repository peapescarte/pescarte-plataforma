defmodule PlataformaDigital.Researcher.ListReportLive do
  use PlataformaDigital, :auth_live_view

  alias PlataformaDigital.Authentication

  @impl true
  def mount(_params, _session, socket) do
    list = %{
      data: "4/5/2023",
      tipo: "Mensal",
      name: "Relatório Mensal - Maio",
      age: "Maio/2023",
      relatorio_mensal_pesquisa: %{
        ano: "2023",
        mes: "julho",
        status: "Entregue"
      }
    }

    {:ok, assign(socket, user: list)}
  end
end
