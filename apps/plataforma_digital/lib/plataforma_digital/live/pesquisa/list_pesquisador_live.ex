defmodule PlataformaDigital.Pesquisa.ListPesquisadorLive do
  @moduledoc false

  use PlataformaDigital, :auth_live_view

  alias ModuloPesquisa.Handlers.PesquisadorHandler

  @impl true
  def mount(_params, _session, socket) do
    pesquisadores = PesquisadorHandler.list_pesquisadores()

    {:ok, assign(socket, pesquisadores: pesquisadores, tabela: pesquisadores)}
  end

  @impl true
  def handle_params(%{"search" => "true"} = search, _uri, socket) do
    tabela =
      case search do
        %{"cpf" => cpf} -> filter_by("cpf", socket.assigns.pesquisadores, cpf)
        %{"bolsa" => bolsa} -> filter_by("bolsa", socket.assigns.pesquisadores, bolsa)
        %{"nome" => nome} -> filter_by("nome", socket.assigns.pesquisadores, nome)
        %{"email" => email} -> filter_by("email", socket.assigns.pesquisadores, email)
      end

    {:noreply, assign(socket, tabela: tabela)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp filter_by("bolsa", pesquisadores, bolsa) do
    Enum.filter(pesquisadores, fn pesquisador ->
      to_string(pesquisador.bolsa) == bolsa
    end)
  end

  defp filter_by("cpf", pesquisadores, cpf) do
    Enum.filter(pesquisadores, fn pesquisador ->
      pesquisador.cpf == cpf
    end)
  end

  defp filter_by("nome", pesquisadores, nome) do
    Enum.filter(pesquisadores, fn pesquisador ->
      pesquisador.nome == nome
    end)
  end

  defp filter_by("email", pesquisadores, email) do
    Enum.filter(pesquisadores, fn pesquisador ->
      pesquisador.email == email
    end)
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
