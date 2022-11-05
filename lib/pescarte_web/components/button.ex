defmodule PescarteWeb.Components.Button do
  @moduledoc false

  use PescarteWeb, :component

  alias PescarteWeb.Components.Icon

  def render(assigns) do
    ~H"""
    <div class={
      ["btn", "btn-#{assigns[:size] || "small"}", if(has_icon?(assigns[:icon]), do: "btn-icon")]
    }>
      <%= link to: @path, method: assigns[:method] || :get do %>
        <%= if assigns[:icon] do %>
          <Icon.render name={@icon} />
        <% end %>
        <%= @label %>
      <% end %>
    </div>
    """
  end

  defp has_icon?(nil), do: false
  defp has_icon?(_), do: true
end
