defmodule PescarteWeb.Pesquisa.RelatorioLive.Index do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Handlers.PesquisadorHandler
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.Pesquisa.RelatorioLive.FormComponent

  @filter_fields [{:tipo, op: :ilike}]

  @impl true
  def mount(_params, _session, socket) do
    case PesquisadorHandler.list_relatorios_pesquisa() do
      {:ok, {relatorios, meta}} ->
        {:ok,
         socket
         |> stream(:relatorios, relatorios)
         |> assign_new(:form, &make_compile_form/1)
         |> assign(meta: meta, filter_fields: @filter_fields)}

      {:error, _meta} ->
        {:ok, push_navigate(socket, to: ~p"/app/pesquisa/relatorios")}
    end
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case PesquisadorHandler.list_relatorios_pesquisa(params) do
      {:ok, {relatorios, meta}} ->
        {:noreply,
         socket
         |> apply_action(socket.assigns.live_action, params)
         |> stream(:relatorios, relatorios, reset: true)
         |> assign(meta: meta)}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/app/pesquisa/relatorios")}
    end
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
    |> assign(:pesquisador_id, socket.assigns.current_researcher.id)
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
    |> assign(:pesquisador_id, socket.assigns.current_researcher.id)
  end

  defp make_compile_form(_assigns) do
    import Ecto.Changeset
    {relatorios, _} = Repository.list_relatorios_pesquisa(%Flop{})
    indexed_relatorios = Enum.with_index(relatorios)

    types =
      indexed_relatorios
      |> Enum.map(fn {_, idx} -> {String.to_atom("relatorio_#{idx}"), :string} end)
      |> Map.new()

    data =
      indexed_relatorios
      |> Enum.map(fn {relatorio, idx} ->
        {String.to_atom("relatorio_#{idx}"), relatorio.id}
      end)
      |> Map.new()

    {%{}, types}
    |> cast(data, Map.keys(types))
    |> to_form(as: :relatorio_compile)
  end
end
