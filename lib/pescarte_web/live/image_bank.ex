defmodule PescarteWeb.ImageBank do
  use PescarteWeb, :live_view

  alias Pescarte.ModuloPesquisa.Repository
  alias Pescarte.ModuloPesquisa.Handlers.MidiasHandler

  @impl true
  def mount(_params, _session, socket) do
    list = Enum.sort_by(MidiasHandler.list_midia(), &(&1.data_arquivo), :desc)

    #REPLACE FOR QUERY THAT RETURNS ALL TAG_ETIQUETAS
    all_tags = MidiasHandler.list_tag();

    tagsCardData = [];
    tagsCardData =
      for tag <- Enum.take(all_tags, 5) do
        tagsCardData = %{
          etiqueta: tag.etiqueta,
          is_selected: false
        }
      end

    socket = assign(socket, :all_midia, list);
    socket = assign(socket, :page, 1);
    socket = assign(socket, :content_mock, ["teste1", "teste2", "teste3"]);

    {:ok,
      socket
      |> assign(tagList: tagsCardData)
      |> assign(all_loaded: length(list) <= 6)
      |> assign(destaques: Enum.take(list, 3))
      |> stream_configure(:midias, dom_id: & &1.id_publico)
      |> stream(:midias, Enum.take(list, 6))}
  end

  def handle_event("load_more", _, socket) do

    socket = assign(socket, :page, socket.assigns.page + 1);
    loaded_midia = Enum.take(MidiasHandler.list_midia(), socket.assigns.page * 6)

    {:noreply,
      socket
      |> assign(all_loaded: length(loaded_midia) <= socket.assigns.page * 6)
      |> stream(:midias, loaded_midia)}
  end

  def handle_event("toggle_tag_filter",  %{"ref" => ref}, socket) do

    tagList =  socket.assigns.tagList

    tagList = update_in(
      tagList,
      [Access.filter(&(&1.etiqueta == ref))],
      &Map.merge(&1, %{is_selected: !&1.is_selected})
    )

    #REPLACE QUERY BELOW FROM tagLIST FROM ACTIVE QUERYS
    filtered_media = MidiasHandler.list_midia()

    {:noreply,
      socket
      |> assign(tagList: tagList)
      |> assign(page: 1)
      |> assign(all_loaded: length(filtered_media) <= 6)
      |> stream(:midias, Enum.take(filtered_media, 6))}

  end

  def handle_event("handle_submit", _, socket) do

    tag_to_add = %{
      etiqueta: "nova_tag",
      is_selected: true
    }

    tagList = socket.assigns.tagList;

    if (!Enum.find(tagList, fn elem -> elem.etiqueta == "nova_tag" end)) do
      #add tag to tagList
      tagList = [tag_to_add | socket.assigns.tagList]

      #removing last tag from tagList
      tagList = List.delete_at(tagList, length(tagList)-1)


      #REPLACE QUERY BELOW FROM tagLIST FROM ACTIVE QUERYS
      filtered_media = MidiasHandler.list_midia()

      {:noreply,
        socket
        |> assign(tagList: tagList)
        |> assign(page: 1)
        |> assign(all_loaded: length(filtered_media) <= 6)
        |> stream(:midias, Enum.take(filtered_media, 6))}
    else
      {:noreply, socket}
    end
  end

end
