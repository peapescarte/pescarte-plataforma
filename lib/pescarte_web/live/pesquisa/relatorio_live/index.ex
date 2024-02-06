defmodule PescarteWeb.Pesquisa.RelatorioLive.Index do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.Pesquisa.RelatorioLive.FormComponent

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
  def handle_event("mensal_report", _, socket) do
    pesquisador_id = socket.assigns.current_researcher.id_publico

    {:noreply,
     socket
     |> assign(:type, "mensal")
     |> assign(:pesquisador_id, pesquisador_id)
     |> push_patch(to: ~p"/app/pesquisa/relatorios/new")}
  end

  def handle_event("trimestral_report", _, socket) do
    pesquisador_id = socket.assigns.current_researcher.id_publico

    {:noreply,
     socket
     |> assign(:type, "trimestral")
     |> assign(:pesquisador_id, pesquisador_id)
     |> push_patch(to: ~p"/app/pesquisa/relatorios/new")}
  end

  def handle_event("anual_report", _, socket) do
    pesquisador_id = socket.assigns.current_researcher.id_publico

    {:noreply,
     socket
     |> assign(:type, "anual")
     |> assign(:pesquisador_id, pesquisador_id)
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
  def handle_info({FormComponent, {:saved, relatorio}}, socket) do
    {:noreply, stream_insert(socket, :relatorios, relatorio)}
  end
end
