defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 3]

  alias Pescarte.Identidades.Models.Usuario
  alias PescarteWeb.LoginLive
  alias Supabase.GoTrue

  require Logger

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

  defp to_live_view_session(conn) do
    %{
      "user_token" => get_session(conn, :user_token),
      "current_user" => conn.assigns[:current_user]
    }
  end
end
