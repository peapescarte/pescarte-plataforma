defmodule PescarteWeb.Pesquisa.RelatorioLive.Index do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  alias Pescarte.ModuloPesquisa.Repository

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:relatorios, dom_id: & &1.id_publico)
     |> stream(:relatorios, Repository.list_relatorios_pesquisa())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("report-type", %{"type" => type}, socket) do
    {:noreply,
     socket
     |> assign(:type, type)
     |> push_patch(to: ~p"/app/pesquisa/relatorios/new")}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Relatório")
    |> assign(:relatorio, Repository.fetch_relatorio_pesquisa_by_id(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Relatório")
    |> assign(:relatorio, %RelatorioPesquisa{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Relatórios")
    |> assign(:relatorio, nil)
  end

  @impl true
  def handle_info({PescarteWeb.RelatorioLive.FormComponent, {:saved, relatorio}}, socket) do
    {:noreply, stream_insert(socket, :relatorios, relatorio)}
  end
end
