defmodule PlataformaDigital.Researcher.Relatorio.ListReportLive do
  use PlataformaDigital, :auth_live_view

  alias ModuloPesquisa.Repository

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    list =
      Repository.list_relatorios_pesquisa_from_pesquisador(current_user.pesquisador.id_publico)

    {:ok, assign(socket, relatorios: list)}
  end
end
