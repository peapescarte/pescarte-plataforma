defmodule PescarteWeb.EquipeHTML do
  use PescarteWeb, :html

  embed_templates("equipe_html/*")
  
 def handle_event("dialog", _value, socket) do
    IO.puts("HHHHHHHHEEEEEEEEELLLLLLLLLOOOOOOOOOOOOOOOOOOOOO")
    {:noreply, socket}
  end
 end
