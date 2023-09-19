defmodule PlataformaDigital.Toast do
  import Phoenix.LiveView

  alias Phoenix.LiveView.Utils

  def put_toast(socket, type, message) do
    {:noreply, Utils.assign(socket, toast: %{type: type, message: message})}
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, attach_hook(socket, :toast_receiver, :handle_info, &maybe_receive_toast/2)}
  end

  defp maybe_receive_toast({:put_toast, type, message}, socket) do
    {:halt, put_toast(socket, type, message)}
  end

  defp maybe_receive_toast(_, socket), do: {:cont, socket}
end
