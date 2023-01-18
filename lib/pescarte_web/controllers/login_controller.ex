defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  alias Pescarte.Domains.Accounts
  alias PescarteWeb.UserAuth

  @err_msg "Email ou senha inválidos"

  def new(conn, _params) do
    render(conn, :new, error: nil)
  end

  def create(conn, %{"cpf" => cpf, "password" => password} = params) do
    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      {:ok, user} -> UserAuth.log_in_user(conn, user, params)
      # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
      {:error, :not_found} -> render(conn, :new, error: @err_msg)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
