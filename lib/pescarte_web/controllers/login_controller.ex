defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 3]

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Supabase.Auth
  alias PescarteWeb.LoginLive
  alias Supabase.GoTrue

  require Logger

  # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
  @err_msg "Email ou senha inválidos"

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    with {:ok, user} <- Usuario.fetch_by(cpf: cpf),
         email = user.contato.email_principal,
         params = %{email: email, password: password},
         %Plug.Conn{} = conn <- GoTrue.Plug.log_in_with_password(conn, params) do
      conn
    else
      err ->
        Logger.error(
          "[#{__MODULE__}] ==> Cannot log in user:\nERROR: #{inspect(err, pretty: true)}"
        )

        conn
        |> put_flash(:error, @err_msg)
        |> put_layout(false)
        |> live_render(LoginLive, session: to_live_view_session(conn))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> GoTrue.Plug.log_out_user(:local)
  end

  @cannot_reset_err "Você não possui permissão para acessar essa página"

  def get_reset_pass(conn, %{"token_hash" => token, "type" => "recovery"}) do
    with {:ok, session} <- Auth.verify_otp(%{token_hash: token, type: :recovery}),
         {:ok, _} <- Auth.get_user(session) do
      conn
      |> GoTrue.Plug.put_token_in_session(session.access_token)
      |> redirect(to: ~p"/app/pesquisa/perfil?type=recovery")
    else
      {:error, %{"error_code" => "otp_expired"}} ->
        conn
        |> put_status(:forbidden)
        |> put_flash(:error, "Parece que o código de verificação informado expirou")
        |> put_layout(false)
        |> live_render(LoginLive, session: to_live_view_session(conn))

      {:error, _} ->
        conn
        |> put_status(:forbidden)
        |> put_flash(:error, @cannot_reset_err)
        |> put_layout(false)
        |> live_render(LoginLive, session: to_live_view_session(conn))
    end
  end

  def get_reset_pass(conn, _) do
    conn
    |> put_status(:forbidden)
    |> put_flash(:error, @cannot_reset_err)
    |> put_layout(false)
    |> live_render(LoginLive, session: to_live_view_session(conn))
  end

  defp to_live_view_session(conn) do
    %{
      "user_token" => get_session(conn, :user_token),
      "current_user" => conn.assigns[:current_user]
    }
  end
end
