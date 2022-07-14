defmodule FuschiaWeb.Components.TextArea do
  @moduledoc false

  use FuschiaWeb, :component

  def render(assigns) do
    ~H"""
      <%= textarea @form,
        @field,
        rows: 8,
        cols: 76,
        id: @id,
        placeholder: @placeholder,
        class: "rounded-3xl m-4" %>
    """
  end
end
