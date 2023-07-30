defmodule PlataformaDigital.DesignSystem.SearchInput do
  use Phoenix.LiveComponent

  alias PlataformaDigital.DesignSystem

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(typing?: false)
     |> assign(filtered: [])}
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :content, :list, default: []
  attr :placeholder, :string, default: "Faça uma pesquisa..."
  attr :field, Phoenix.HTML.FormFieldcontent
  attr :size, :string, values: ~w(base large), default: "base"
  attr :patch, :string, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div class={["search-input-wrapper", @size]}>
      <fieldset class={["search-input", if(@typing?, do: "typing", else: "empty")]}>
        <span class="search-icon">
          <Lucideicons.search />
        </span>
        <input
          id={@id}
          name={@name}
          list={@id <> "_data_list"}
          placeholder={@placeholder}
          phx-click-away="dismiss-search"
          phx-keyup="search"
          phx-target={@myself}
          phx-debounce={100}
        />
      </fieldset>
      <ul class={["search-menu", if(@typing?, do: "show", else: "hide")]}>
        <li :for={{key, option} <- @filtered} class="search-menu-option">
          <.link patch={mount_patch_uri(@patch, {key, option})}>
            <DesignSystem.text size="lg">
              <%= option %>
            </DesignSystem.text>
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  defp mount_patch_uri(patch, {key, option}) do
    query = URI.encode_query(Map.put(%{}, key, option))

    patch
    |> URI.parse()
    |> URI.append_query(query)
    |> URI.append_query("search=true")
    |> URI.to_string()
  end

  @impl true
  def handle_event("search", %{"key" => "Backspace", "value" => ""}, socket) do
    {:noreply, reset_search(socket)}
  end

  def handle_event("search", %{"key" => "Escape"}, socket) do
    {:noreply, reset_search(socket)}
  end

  def handle_event("search", %{"value" => value}, socket) do
    case render_matches(socket.assigns.content, value) do
      [] ->
        {:noreply, socket}

      filtered ->
        {:noreply,
         socket
         |> assign(typing?: true)
         |> assign(filtered: filtered)}
    end
  end

  def handle_event("dismiss-search", _params, socket) do
    {:noreply, reset_search(socket)}
  end

  defp reset_search(socket) do
    socket
    |> assign(typing?: false)
    |> assign(filtered: [])
  end

  defp render_matches(content, value) do
    content
    |> Enum.map(&render_map/1)
    |> List.flatten()
    |> Enum.filter(fn {_, v} -> String.downcase(v) =~ value end)
  end

  defp render_map(map) do
    Enum.map(map, fn {key, value} ->
      if is_map(value) do
        render_map(value)
      else
        {key, to_string(value)}
      end
    end)
  end
end
