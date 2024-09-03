defmodule PescarteWeb.Noti1HTML do
  use PescarteWeb, :html

  embed_templates("noti1_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
