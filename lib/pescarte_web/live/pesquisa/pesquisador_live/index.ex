defmodule PescarteWeb.Pesquisa.PesquisadorLive.Index do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.GetPesquisador
  alias Pescarte.ModuloPesquisa.Handlers.PesquisadorHandler
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias PescarteWeb.Pesquisa.PesquisadorLive.FormComponent

  @filter_fields [{:nome, op: :ilike}]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, filter_fields: @filter_fields)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case PesquisadorHandler.list_pesquisadores(params) do
      {:ok, {pesquisadores, meta}} ->
        {:noreply,
         socket
         |> assign(pesquisadores: pesquisadores, meta: meta)
         |> apply_action(socket.assigns.live_action, params)}

      {:error, _meta} ->
        {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Cadastrar Novo Pesquisador")
    |> assign(:pesquisador, %Pesquisador{})
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Perfil Pesquisador")
    |> assign(:pesquisador, GetPesquisador.run(id: id))
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Seu Perfil")
    |> assign(:pesquisador, socket.assigns.current_usuario.pesquisador)
  end

  defp apply_action(socket, :index, params) do
    case PesquisadorHandler.list_pesquisadores(params) do
      {:ok, {pesquisadores, meta}} ->
        socket
        |> assign(:page_title, "Lista de Pesquisadores")
        |> assign(:pesquisador, nil)
        |> assign(:meta, meta)
        |> stream(:pesquisadores, pesquisadores)

      {:error, _meta} ->
        push_navigate(socket, to: ~p"/app/pesquisa/pesquisadores")
    end
  end

  @spec humanize_bolsa(atom) :: String.t()
  def humanize_bolsa(bolsa) do
    bolsa
    |> Atom.to_string()
    |> Phoenix.Naming.humanize()
  end
end
