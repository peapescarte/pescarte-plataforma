defmodule PescarteWeb.DesignSystem.MultipleSelectInput do
  use PescarteWeb, :live_component

  use Ecto.Schema

  embedded_schema do
    embeds_many :options, SelectOption do
      field :label, :string
      field :value, :string
      field :selected, :boolean, default: false
    end
  end

  attr :id, :string, default: nil
  attr :name, :string, default: nil
  attr :label, :string
  attr :prompt, :string, default: ""
  attr :options, :list, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <fieldset
      class="dropdown"
      id={"#{@id}-dropdown"}
      phx-click-away="close_dropdown"
      phx-target={@myself}
    >
      <label :if={@label} for={@name}>
        <.text size="h4"><%= @label %></.text>
      </label>
      <div phx-click="toggle_dropdown" phx-target={@myself} class="dropdown-button">
        <%= if Enum.any?(@options, & &1.selected) do %>
          <span class="selection">
            <%= Enum.map_join(Enum.filter(@options, & &1.selected), ", ", & &1.label) %>
          </span>
        <% else %>
          <%= @prompt %>
        <% end %>
        <div class="icon">
          <Lucideicons.chevron_down :if={!@open} />
          <Lucideicons.chevron_up :if={@open} />
        </div>
      </div>
      <ul class={["dropdown-options", if(@open, do: "flex", else: "hidden")]}>
        <li
          :for={opt <- @options}
          phx-click="select_option"
          phx-target={@myself}
          phx-value-content={opt.value}
          class={opt.selected && "selected"}
        >
          <%= opt.label %>
        </li>
      </ul>
      <select id={@id} name={@name} multiple>
        <option :for={opt <- @options} value={opt.value} selected={opt.selected}>
          <%= opt.label %>
        </option>
      </select>
    </fieldset>
    """
  end

  @impl true
  def update(%{field: %Phoenix.HTML.FormField{} = field} = params, socket) do
    {:ok,
     socket
     |> assign(field: nil, prompt: params.prompt, open: false)
     |> assign(id: params.id || field.id, label: params[:label])
     |> assign_new(:name, fn -> field.name <> "[]" end)
     |> assign_new(:value, fn -> field.value end)
     |> assign(options: Enum.map(params.options, &parse_options/1))}
  end

  defp parse_options({label, value}) do
    %__MODULE__.SelectOption{label: label, value: value, selected: false}
  end

  defp parse_options(label) when is_binary(label) do
    %__MODULE__.SelectOption{label: label, value: label, selected: false}
  end

  @impl true
  def handle_event("toggle_dropdown", _, socket) do
    {:noreply, assign(socket, open: !socket.assigns.open)}
  end

  def handle_event("close_dropdown", _, socket) do
    {:noreply, assign(socket, open: false)}
  end

  def handle_event("select_option", %{"content" => opt_value}, socket) do
    current = socket.assigns.options
    select_callback = fn opt -> select_option(opt, opt_value) end
    updated = Enum.map(current, select_callback)
    # send(self(), {:selected_options, Enum.filter(updated, & &1.selected)})

    {:noreply, assign(socket, options: updated)}
  end

  defp select_option(opt, single) do
    if opt.value == single do
      %{opt | selected: !opt.selected}
    else
      opt
    end
  end
end
