defmodule PescarteWeb.ImageBank do
  use PescarteWeb, :live_view

  alias Pescarte.ModuloPesquisa.Repository
  alias Pescarte.ModuloPesquisa.Handlers.MidiasHandler

  @impl true
  def mount(_params, _session, socket) do
    list = Enum.sort_by(MidiasHandler.list_midia(), &(&1.data_arquivo), :desc)

    tagsCardData = [];
    tagsCardData =
      for tag <- Enum.take(MidiasHandler.list_tag(), 5) do
        tagsCardData = %{
          etiqueta: tag.etiqueta,
          is_selected: false
        }
      end

    socket = assign(socket, :all_midia, list);
    socket = assign(socket, :page, 1);

    {:ok,
      socket
      |> assign(tagList: tagsCardData)
      |> assign(destaques: Enum.take(list, 3))
      |> stream_configure(:midias, dom_id: & &1.id_publico)
      |> stream(:midias, Enum.take(list, 6))}
  end
  def handle_event("load_more", _, socket) do
    socket = assign(socket, :page, socket.assigns.page + 1);
    {:noreply, stream(socket, :midias, Enum.take(MidiasHandler.list_midia(), socket.assigns.page * 6))}
  end

  def handle_event("toggle_tag_filter",  %{"ref" => ref}, socket) do

    tagList =  socket.assigns.tagList

    tagList = update_in(
      tagList,
      [Access.filter(&(&1.etiqueta == ref))],
      &Map.merge(&1, %{is_selected: !&1.is_selected})
    )

    IO.inspect(tagList)

    {:noreply, assign(socket, tagList: tagList)}
  end

end
