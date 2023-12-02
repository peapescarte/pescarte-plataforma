defmodule PescarteWeb.Pesquisa.RelatorioLive.Show do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Repository

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:relatorio, Repository.fetch_relatorio_pesquisa_by_id(id))}
  end

  defp page_title(:show), do: "Mostrar Relatório"
  defp page_title(:edit), do: "Editar Relatório"
end
