defmodule FuschiaWeb.ExampleLive do
  use FuschiaWeb, :live_view

  alias FuschiaWeb.Components.Example

  def render(assigns) do
    ~F"""
    <Example>
      Hi There
    </Example>
    """
  end
end
