defmodule PlataformaDigital.Pesquisa.Relatorio.ListReportLive do
  use PlataformaDigital, :auth_live_view

  #  alias ModuloPesquisa.Repository

  alias ModuloPesquisa.Handlers.RelatoriosHandler

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    list =
      if current_user == :admin do
        RelatoriosHandler.list_relatorios()
      else
        RelatoriosHandler.list_relatorios_from_pesquisador(current_user.pesquisador.id_publico)
      end

    {:ok, assign(socket, relatorios: list)}
  end
end
