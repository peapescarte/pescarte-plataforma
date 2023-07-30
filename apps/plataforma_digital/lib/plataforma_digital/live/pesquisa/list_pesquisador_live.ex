defmodule PlataformaDigital.Pesquisa.ListPesquisadorLive do
  @moduledoc false

  use PlataformaDigital, :auth_live_view

  @impl true
  def mount(_params, _session, socket) do
    pesquisadores = [
      %{
        bolsa: :pesquisa,
        usuario: %{
          cpf: "133.590.177-90",
          primeiro_nome: "Zoey",
          contato: %{
            email: "zoey.spessanha@outlook.com"
          }
        }
      }
    ]

    {:ok, assign(socket, pesquisadores: pesquisadores)}
  end

  @spec humanize_bolsa(atom) :: String.t()
  def humanize_bolsa(bolsa) do
    bolsa
    |> Atom.to_string()
    |> Phoenix.Naming.humanize()
  end

  @impl true
  def handle_event("register", _params, socket) do
    {:noreply, socket}
  end
end
