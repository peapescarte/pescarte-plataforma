defmodule PescarteWeb.AboutUsHTML do
  use PescarteWeb, :html

  embed_templates("aboutus_html/*")

  def handle_event("dialog", _value, socket) do
    IO.puts("HII")

    {:noreply, socket}
  end
end
