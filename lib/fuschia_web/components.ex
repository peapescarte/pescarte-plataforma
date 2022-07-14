defmodule FuschiaWeb.Components do
  @moduledoc false

  alias FuschiaWeb.Components.{
    Footer,
    Icon,
    Navbar,
    TextArea
  }

  defdelegate footer(assigns), to: Footer, as: :render

  defdelegate icon(assigns), to: Icon, as: :render

  defdelegate navbar(assigns), to: Navbar, as: :render

  defdelegate textarea(assigns), to: TextArea, as: :render
end
