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
          phx-keyup="search"
          phx-target={@myself}
          phx-debounce={100}
        />
      </fieldset>
      <ul class={["search-menu", if(@typing?, do: "show", else: "hide")]}>
        <li :for={option <- maybe_render_content(@content, @filtered)} class="search-menu-option">
          <.link patch="/">
            <DesignSystem.text size="lg">
              <%= option %>
            </DesignSystem.text>
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  @impl true
  def handle_event("search", %{"key" => "Backspace", "value" => ""}, socket) do
    {:noreply,
     socket
     |> assign(typing?: false)
     |> assign(filtered: [])}
  end

  def handle_event("search", %{"value" => value}, socket) do
    case maybe_display_matches(socket.assigns.content, value) do
      [] ->
        {:noreply, socket}

      filtered ->
        {:noreply,
         socket
         |> assign(typing?: true)
         |> assign(filtered: filtered)}
    end
  end

  defp maybe_display_matches(content, value) do
    matches = Enum.filter(content, &(&1 =~ value))
    if Enum.empty?(matches), do: content, else: matches
  end

  defp maybe_render_content(content, []), do: content
  defp maybe_render_content(_content, filtered), do: filtered
end
