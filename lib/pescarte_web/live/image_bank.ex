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


    {:ok,
      socket
      |> assign(tagList: tagsCardData)
      |> assign(all_loaded: length(list) <= 6)
      |> assign(destaques: Enum.take(list, 3))
      |> assign(:text_value, nil)
      |> stream_configure(:midias, dom_id: & &1.id_publico)
      |> stream(:midias, Enum.take(list, 6))}
  end

  def handle_event("load_more", _, socket) do

    socket = assign(socket, :page, socket.assigns.page + 1);
    loaded_midia = Enum.take(get_midias(socket.assigns.tagList), socket.assigns.page * 6)

    {:noreply,
      socket
      |> assign(all_loaded: length(loaded_midia) <= socket.assigns.page * 6)
      |> stream(:midias, loaded_midia)}
  end

  def handle_event("toggle_tag_filter",  %{"ref" => ref}, socket) do

    IO.puts(ref)
    tagList =  socket.assigns.tagList

    tagList = update_in(
      tagList,
      [Access.filter(&(&1.etiqueta == ref))],
      &Map.merge(&1, %{is_selected: !&1.is_selected})
    )

    filtered_media = get_midias(tagList)

    {:noreply,
      socket
      |> assign(tagList: tagList)
      |> assign(page: 1)
      |> assign(all_loaded: length(filtered_media) <= 6)
      |> stream(:midias, Enum.take(filtered_media, 6))}

  end

  def handle_event("search", %{"value" => message}, socket) do

    tag_to_add = %{
      etiqueta: message,
      is_selected: true
    }

    tagList = socket.assigns.tagList;

    if (!Enum.find(tagList, fn elem -> elem.etiqueta == message end)) do
      #add tag to tagList
      tagList = [tag_to_add | socket.assigns.tagList]

      #removing last tag from tagList
      tagList = List.delete_at(tagList, length(tagList)-1)

      #REPLACE QUERY BELOW FROM tagLIST FROM ACTIVE QUERYS
      filtered_media = get_midias(tagList)

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

  # função limpa o tagList para apenas uma lista de strings com as tags selecionadas
  def reduce_taglist(taglist) do
    reduced = [];
    reduced =
      for tag <- taglist do
        if (tag.is_selected) do
        reduced = tag.etiqueta
        end
      end

    Enum.filter(reduced, & !is_nil(&1))
  end

  # função recebe lista de tags e retorna lista de midias filtradas ou todas midias caso vazias
  def get_midias(taglist \\ []) do
    reduced_taglist = reduce_taglist(taglist)
    if (length(reduced_taglist) > 0) do
      filtered_media = Repository.list_midias_from_tags(reduced_taglist)
    else
      filtered_media = MidiasHandler.list_midia()
    end
  end
end
