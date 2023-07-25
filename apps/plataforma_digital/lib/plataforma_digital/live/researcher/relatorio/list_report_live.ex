defmodule PlataformaDigital.Researcher.Relatorio.ListReportLive do
  use PlataformaDigital, :auth_live_view

  alias PlataformaDigital.Authentication

  @impl true
  def mount(_params, _session, socket) do
  #  current_user = socket.assigns.current_user
    list = [
      %{data: "4/5/2023", tipo: "Mensal",  name: "Relatório Mensal - Maio",
        ano: "2023", mes: "Maio", status: "Entregue" 
      },
      %{data: "4/5/2023", tipo: :Anual,  name: "Relatório Mensal - Julho",
        ano: "2023", mes: "Maio", status: "Atrasado"
      }]
    {:ok, assign(socket, relatorios: list)}
  end
end
