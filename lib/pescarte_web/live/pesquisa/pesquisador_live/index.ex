defmodule PescarteWeb.Pesquisa.PesquisadorLive.Index do
  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Repository
  alias PescarteWeb.Pesquisa.PesquisadorLive.FormComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Pesquisador")
    |> assign(:pesquisador, %Pesquisador{})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Cadastrar Novo Pesquisador")
    |> assign(:pesquisador, %Pesquisador{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Pesquisadores")
    |> assign(:pesquisador, nil)
  end
end
