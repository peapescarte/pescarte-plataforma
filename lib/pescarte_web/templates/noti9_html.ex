defmodule PescarteWeb.Noti9HTML do
  use PescarteWeb, :html

  embed_templates("noti9_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
