defmodule PescarteWeb.EquipesHTML do
  use PescarteWeb, :html

  embed_templates("equipes_html/*")

  def handle_event("dialog", _value, socket) do
    {:noreply, socket}
  end
end
