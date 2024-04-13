defmodule PescarteWeb.DesignSystem.SearchInput do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, assign(socket, typing?: false)}
  end

  attr :id, :string, required: true
  attr :meta, Flop.Meta, required: true
  attr :placeholder, :string, default: "Faça uma pesquisa..."
  attr :size, :string, values: ~w(base large), default: "base"
  attr :patch, :string, required: true
  attr :fields, :list, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div class={["search-input-wrapper", @size]}>
      <.form
        :let={f}
        for={@meta}
        phx-keyup="search"
        phx-click-away="dismiss-search"
        id={@id <> "_form"}
        phx-target={@myself}
        phx-change="search"
        phx-submit="search"
      >
        <fieldset class={["search-input", if(@typing?, do: "typing", else: "empty")]}>
          <Flop.Phoenix.hidden_inputs_for_filter form={f} />

          <span class="search-icon">
            <Lucideicons.search />
          </span>

          <.inputs_for :let={ff} field={f[:filters]} options={[fields: @fields]}>
            <Flop.Phoenix.hidden_inputs_for_filter form={ff} />
            <input
              id={ff[:value].id}
              name={ff[:value].name}
              value={ff[:value].value}
              placeholder={@placeholder}
              phx-debounce={100}
            />
          </.inputs_for>
        </fieldset>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("search", %{"key" => "Backspace", "value" => ""}, socket) do
    {:noreply, reset_search(socket)}
  end

  def handle_event("search", %{"key" => "Escape"}, socket) do
    {:noreply, reset_search(socket)}
  end

  def handle_event("search", params, socket) do
    params = Map.delete(params, "_target")
    patch = socket.assigns.patch
    encoded_params = Plug.Conn.Query.encode(params)
    {:noreply, push_patch(socket, to: "#{patch}?#{encoded_params}")}
  end

  def handle_event("dismiss-search", _params, socket) do
    {:noreply, reset_search(socket)}
  end

  defp reset_search(socket) do
    patch = socket.assigns.patch

    socket
    |> assign(typing?: false)
    |> push_patch(to: "#{patch}?filters[]=")
  end
end
