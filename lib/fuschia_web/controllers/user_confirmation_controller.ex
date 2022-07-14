defmodule FuschiaWeb.UserConfirmationController do
  @moduledoc false

  use FuschiaWeb, :controller

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
    |> put_flash(:info, message())
    |> redirect(to: "/")
  end

  # Não faça login do usuário após a confirmação para evitar um
  # token vazado dando ao usuário acesso à conta.
  def update(conn, %{"token" => token}) do
    # Se houver um usuário atual e a conta já foi confirmada,
    # então as chances são de que o link de confirmação já foi visitado, ou
    # por alguma forma automática ou pelo próprio usuário, então redirecionamos sem
    # uma mensagem de aviso.
    with :error <- Accounts.confirm_user(token),
         %{current_user: %{confirmed_at: %NaiveDateTime{} = _confirmed_at}} <- conn.assigns do
      redirect(conn, to: "/")
    else
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User confirmed successfully.")
        |> redirect(to: "/")

      %{} ->
        conn
        |> put_flash(
          :error,
          "User confirmation link is invalid or it has expired."
        )
        |> redirect(to: "/")
    end
  end

  defp message do
    """
    If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly.
    """
  end
end
