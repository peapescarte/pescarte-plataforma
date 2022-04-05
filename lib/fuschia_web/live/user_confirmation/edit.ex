defmodule FuschiaWeb.UserConfirmationLive.Edit do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias Surface.Components.Form

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"token" => token}, _uri, socket) do
    {:noreply, assign(socket, token: token)}
  end

  # Não faça login do usuário após a confirmação para evitar um
  # token vazado dando ao usuário acesso à conta.
  def handle_event("confirm", _payload, socket) do
    # Se houver um usuário atual e a conta já foi confirmada,
    # então as chances são de que o link de confirmação já foi visitado, ou
    # por alguma forma automática ou pelo próprio usuário, então redirecionamos sem
    # uma mensagem de aviso.
    token = socket.assigns.token

    with :error <- Accounts.confirm_user(token),
         %{current_user: %{confirmed_at: %NaiveDateTime{} = _confirmed_at}} <- socket.assigns do
      {:noreply, redirect(socket, to: "/app")}
    else
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, dgettext("infos", "User confirmed successfully."))
         |> redirect(to: "/app")}

      %{} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           dgettext("errors", "User confirmation link is invalid or it has expired.")
         )
         |> redirect(to: "/")}
    end
  end
end
