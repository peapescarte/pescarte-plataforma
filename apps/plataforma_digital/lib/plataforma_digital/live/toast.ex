defmodule PlataformaDigital.Toast do
  import Phoenix.LiveView

  def put_toast(socket, type, message) do
    send(self(), {:put_toast, type, message})
    socket
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, attach_hook(socket, :toast, :handle_info, &maybe_receive_toast/2)}
  end

  defp maybe_receive_toast({:put_toast, type, message}, socket) do
    {:halt, put_toast(socket, type, message)}
  end

  defp maybe_receive_toast(_, socket), do: {:cont, socket}
end
