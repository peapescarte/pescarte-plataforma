defmodule PescarteWeb.Flash do
  use PescarteWeb, :live_view

  def on_mount(:flash, _params, _session, socket) do
    Process.send_after(self(), :hide_flash, 10_000)
    socket = attach_hook(socket, :hide_flash, :handle_info, &hide_flash/2)

    {:cont, socket}
  end

  defp hide_flash(:hide_flash, socket) do
    {:halt, clear_flash(socket)}
  end
end
