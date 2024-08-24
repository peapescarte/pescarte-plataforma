defmodule PescarteWeb.PgtrsHTML do
  use PescarteWeb, :html

  embed_templates("pgtrs_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
