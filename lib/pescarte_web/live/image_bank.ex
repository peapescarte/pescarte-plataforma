defmodule PlataformaDigital.ImageBank do
  use PlataformaDigital, :live_view

  alias ModuloPesquisa.Repository
  alias ModuloPesquisa.Handlers.MidiasHandler

  @impl true
  def mount(_params, _session, socket) do
    list = Enum.sort_by(MidiasHandler.list_midia(), &(&1.data_arquivo), :desc)

    socket = assign(socket, :midias, Enum.take(list, 6));

    socket = assign(socket, :all_midia, list);
    socket = assign(socket, :val, 0);

    {:ok, assign(socket, destaques: Enum.take(list, 3), temporary_assigns: [midias: []])}
  end

  def handle_event("load_more", _, socket) do
    IO.puts("\nTESTE CHAMADO\n")
    {:noreply, update(socket, :midias, :all_midia)}
  end

end
