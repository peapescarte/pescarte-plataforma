defmodule PescarteWeb.Pesquisa.ListPesquisadorLive do
  @moduledoc false

  use PescarteWeb, :auth_live_view

  alias Pescarte.ModuloPesquisa.Handlers.PesquisadorHandler

  # @filter_fields [{:name, op: :ilike}, {:email, op: :ilike}, {:cpf, op: :ilike}, {:bolsa, op: :ilike}]
  @filter_fields [{:nome, op: :ilike}]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, filter_fields: @filter_fields)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case PesquisadorHandler.list_pesquisadores(params) do
      {:ok, {pesquisadores, meta}} ->
        {:noreply, assign(socket, pesquisadores: pesquisadores, meta: meta)}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/app/pesquisa/pesquisadores")}
    end
  end

  @impl true
  def handle_event("register", _params, socket) do
    {:noreply, socket}
  end

  @spec humanize_bolsa(atom) :: String.t()
  def humanize_bolsa(bolsa) do
    bolsa
    |> Atom.to_string()
    |> Phoenix.Naming.humanize()
  end
end
