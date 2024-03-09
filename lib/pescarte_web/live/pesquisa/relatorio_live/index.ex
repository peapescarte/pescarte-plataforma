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
  def handle_event("relatorio_mensal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/pesquisa/relatorios/novo/mensal")}
  end

  def handle_event("relatorio_trimestral", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/pesquisa/relatorios/novo/trimestral")}
  end

  def handle_event("relatorio_anual", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/app/pesquisa/relatorios/novo/anual")}
  end

  @impl true
  def handle_info({FormComponent, {:saved, relatorio}}, socket) do
    {:noreply, stream_insert(socket, :relatorios, relatorio)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "tipo" => tipo_relatorio}) do
    case Repository.fetch_relatorio_pesquisa_by_id_and_kind(id, tipo_relatorio) do
      nil ->
        redirect_to_report_listing(socket)

      relatorio ->
        assign_report_to_form(socket, relatorio, tipo_relatorio)
    end
  end

  defp apply_action(socket, :new, %{"tipo" => tipo_relatorio}) do
    socket
    |> assign(:page_title, "Novo Relatório")
    |> assign(:relatorio, %RelatorioPesquisa{})
    |> assign(:tipo, tipo_relatorio)
    |> assign(:pesquisador_id, socket.assigns.current_researcher.id_publico)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Relatórios")
    |> assign(:relatorio, nil)
  end

  defp redirect_to_report_listing(socket) do
    push_patch(socket, to: ~p"/app/pesquisa/relatorios")
  end

  defp assign_report_to_form(socket, relatorio, tipo_relatorio) do
    socket
    |> assign(:page_title, "Editar Relatório")
    |> assign(:relatorio, relatorio)
    |> assign(:tipo, tipo_relatorio)
    |> assign(:pesquisador_id, socket.assigns.current_researcher.id_publico)
  end
end
