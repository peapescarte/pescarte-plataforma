defmodule PlataformaDigital.DesignSystem.SearchInput do
  use Phoenix.LiveComponent
  alias PlataformaDigital.DesignSystem

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :content, :list, default: []
  attr :placeholder, :string, default: ""
  attr :field, Phoenix.HTML.FormField

  @placeholder "Faça uma pesquisa..."

  # mount(socket) -> render(assigns)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(show_list?: false)
     |> assign(placeholder: @placeholder)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <fieldset class="search-input">
      <div class="search-icon">
        <Lucideicons.search />
      </div>
      <input
        id={@id}
        name={@name}
        list={@id <> "_data_list"}
        placeholder={@placeholder}
        phx-keyup="search"
        phx-target={@myself}
        phx-debounce={300}
      />
      <ul class={["search-menu", if(@show_list?, do: "block", else: "hidden")]}>
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
     |> assign(show_list?: true)
     |> assign(content: content)}
  end

  defp maybe_display_matches(content, value) do
    matches = Enum.filter(content, &(&1 =~ value))
    if Enum.empty?(matches), do: content, else: matches
  end
end
