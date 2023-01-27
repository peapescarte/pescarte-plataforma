defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  alias Pescarte.Domains.Accounts
  alias PescarteWeb.UserAuthentication

  @err_msg "Email ou senha inválidos"

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      {:ok, user} ->
        UserAuthentication.log_in_user(conn, user, user_params)

      # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
      {:error, :not_found} ->
        render(conn, :new, error: @err_msg)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> UserAuthentication.log_out_user()
  end
end
