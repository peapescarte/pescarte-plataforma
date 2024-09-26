defmodule PescarteWeb.Noti7HTML do
  use PescarteWeb, :html

  embed_templates("noti7_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
