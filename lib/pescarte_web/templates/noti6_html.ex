defmodule PescarteWeb.Noti6HTML do
  use PescarteWeb, :html

  embed_templates("noti6_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
