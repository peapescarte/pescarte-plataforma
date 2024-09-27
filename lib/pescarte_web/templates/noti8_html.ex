defmodule PescarteWeb.Noti8HTML do
  use PescarteWeb, :html

  embed_templates("noti8_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
