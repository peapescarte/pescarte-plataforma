defmodule PescarteWeb.PesquisadoresLive do
  use PescarteWeb, :live_view

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    pesquisadores = ModuloPesquisa.list_pesquisador()

    {:ok,
     socket
     |> assign(user: user)
     |> assign(pesquisadores: pesquisadores)}
  end

  ## Eventos

  def handle_event("filtrar", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cadastrar", _params, socket) do
    {:noreply, socket}
  end

  ## Componentes

  def render(assigns) do
    ~H"""
    <section class="pesquisadores-lista">
      <div>
        <.button style="primary">
          <.text size="base" color="white-100">
            Filtros
          </.text>
        </.button>
        <.button :if={@user.role} style="primary" phx-click="cadastrar">
          <.text size="base" color="white-100">
            Cadastrar
          </.text>
        </.button>
      </div>
      <.table id="pesquisadores" rows={@pesquisadores}>
        <:col :let={pesquisador} label="Nome">
          <.text text_case="capitalize" color="black-80">
            <%= User.full_name(pesquisador.user) %>
          </.text>
        </:col>

        <:col :let={pesquisador} label="CPF">
          <.text color="black-80">
            <%= pesquisador.user.cpf %>
          </.text>
        </:col>

        <:col :let={pesquisador} label="Email">
          <.text color="black-80">
            <%= pesquisador.user.contato.email %>
          </.text>
        </:col>

        <:col :let={pesquisador} label="Participação">
          <.text text_case="capitalize" color="black-80">
            <%= pesquisador.bolsa %>
          </.text>
        </:col>
      </.table>
    </section>
    """
  end
end
