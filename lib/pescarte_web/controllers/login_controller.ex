defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  alias Pescarte.Identidades.Handlers.UsuarioHandler
  alias PescarteWeb.Authentication

  # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
  @err_msg "Email ou senha inválidos"

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    with {:ok, user} <- UsuarioHandler.fetch_usuario_by_cpf_and_password(cpf, password) do
      IO.inspect(user, label: "USUARIO")
      email = user.contato.email_principal
      params = %{email: email, password: password}
      Supabase.GoTrue.Plug.log_in_with_password(conn, params) |> IO.inspect(label: "CONN")
    else
      err -> 
        IO.inspect(err, label: "ERRO")
        render(conn, :show, error_message: @err_msg)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> Supabase.GoTrue.Plug.log_out_user(:local)
  end
end
