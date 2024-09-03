defmodule PescarteWeb.Noti4HTML do
  use PescarteWeb, :html

  embed_templates("noti4_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
