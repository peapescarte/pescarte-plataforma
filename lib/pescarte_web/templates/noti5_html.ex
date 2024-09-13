defmodule PescarteWeb.Noti5HTML do
  use PescarteWeb, :html

  embed_templates("noti5_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
