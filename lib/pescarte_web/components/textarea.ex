defmodule BackendWeb.Components.TextArea do
  @moduledoc false

  use BackendWeb, :component

  def render(assigns) do
    ~H"""
    <%= textarea(
      @form,
      @field,
      rows: 8,
      cols: 76,
      id: assigns[:id] || Atom.to_string(@field),
      placeholder: @placeholder,
      required: true,
      class: "rounded-3xl m-4"
    ) %>
    """
  end
end
