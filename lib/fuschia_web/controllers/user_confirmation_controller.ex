defmodule FuschiaWeb.UserConfirmationController do
  use FuschiaWeb, :controller

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      dgettext(
        "infos",
        "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
      )
    )
    |> redirect(to: "/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Não faça login do usuário após a confirmação para evitar um
  # token vazado dando ao usuário acesso à conta.
  def update(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, dgettext("infos", "User confirmed successfully."))
        |> redirect(to: "/")

      :error ->
        # Se houver um usuário atual e a conta já foi confirmada,
        # então as chances são de que o link de confirmação já foi visitado, ou
        # por alguma forma automática ou pelo próprio usuário, então redirecionamos sem
        # uma mensagem de aviso.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(
              :error,
              dgettext("errors", "User confirmation link is invalid or it has expired.")
            )
            |> redirect(to: "/")
        end
    end
  end
end
