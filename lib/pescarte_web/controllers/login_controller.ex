defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  import Plug.Conn
  import Phoenix.LiveView.Controller, only: [live_render: 3]

  alias Pescarte.Clients.Auth
  alias Pescarte.Identidades.Models.Usuario
  alias PescarteWeb.LoginLive

  require Logger

  @session_cookie "_pea_pescarte_session_cookie"
  @session_cookie_options [sign: true, same_site: "Lax"]

  # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
  @err_msg "Email ou senha inválidos"

  def show(conn, _params) do
    current_path = conn.request_path
    render(conn, :show, current_path: current_path, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    with {:ok, user} <- Usuario.fetch_by(cpf: cpf),
         email = user.contato.email_principal,
         params = %{email: email, password: password},
         {:ok, session} <- Auth.authenticate(params) do
      save_session(conn, session, user_params)
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

  defp save_session(conn, %{token: token} = session, user_params) do
    base64_token = Base.url_encode64(token)

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_session:#{base64_token}")
    |> maybe_write_session_cookie(session, user_params)
  end

    defp maybe_write_session_cookie(conn, session, params) do
    case params do
      %{"remember_me" => "true"} ->
        token = session.access_token
        opts = Keyword.put(@session_cookie_options, :max_age, session.expires_in)
        put_resp_cookie(conn, @session_cookie, token, opts)
      _ -> conn
    end
  end


  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> log_out_user(:local)
  end

    defp log_out_user(%Plug.Conn{} = conn, scope) do
    user_token = get_session(conn, :user_token)
    user_token && Auth.sign_out(user_token, scope)

    live_socket_id = get_session(conn, :live_socket_id)
    endpoint = Application.get_env(:supabase_gotrue, :endpoint)

   if live_socket_id && endpoint do
      endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: ~p"/")
  end


  defp to_live_view_session(conn) do
    %{
      "user_token" => get_session(conn, :user_token),
      "current_user" => conn.assigns[:current_user]
    }
  end
end
