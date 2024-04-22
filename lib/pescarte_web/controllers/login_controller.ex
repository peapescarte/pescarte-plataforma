defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  alias Pescarte.Identidades.Models.Usuario
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
        Logger.error("[#{__MODULE__}] ==> Cannot log in user:\nERROR: #{inspect(err, pretty: true)}")
        render(conn, :show, error_message: @err_msg)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> GoTrue.Plug.log_out_user(:local)
  end
end
