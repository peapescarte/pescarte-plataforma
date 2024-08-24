defmodule PescarteWeb.Noti3HTML do
  use PescarteWeb, :html

  embed_templates("noti3_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
