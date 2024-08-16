defmodule PescarteWeb.CensoHTML do
  use PescarteWeb, :html

  embed_templates("censo_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
