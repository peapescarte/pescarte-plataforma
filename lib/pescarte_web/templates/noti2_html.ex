defmodule PescarteWeb.Noti2HTML do
  use PescarteWeb, :html

  embed_templates("noti2_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
