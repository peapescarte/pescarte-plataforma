defmodule PlataformaDigital.DesignSystem.SearchInput do
  use Phoenix.LiveComponent
  alias PlataformaDigital.DesignSystem

  @impl true
  def mount(socket) do
    {:ok, assign(socket, typing?: false)}
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :content, :list, default: []
  attr :placeholder, :string, default: "Faça uma pesquisa..."
  attr :field, Phoenix.HTML.FormField

  @impl true
  def render(assigns) do
    ~H"""
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
        phx-debounce={300}
      />
      <ul class={["search-menu", if(@typing?, do: "block", else: "hidden")]}>
        <li :for={option <- @content} class="search-menu-option">
          <.link patch="/">
            <DesignSystem.text size="lg">
              <%= option %>
            </DesignSystem.text>
          </.link>
        </li>
      </ul>
    </fieldset>
    """
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    content = maybe_display_matches(socket.assigns.content, value)

    {:noreply,
     socket
     |> assign(typing?: true)
     |> assign(content: content)}
  end

  defp maybe_display_matches(content, value) do
    matches = Enum.filter(content, &(&1 =~ value))
    if Enum.empty?(matches), do: content, else: matches
  end
end
