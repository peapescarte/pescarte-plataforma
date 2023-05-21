defmodule PescarteWeb.LoginController do
  use PescarteWeb, :controller

  alias Pescarte.Domains.Accounts
  alias PescarteWeb.Authentication

  # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
  @err_msg "Email ou senha inválidos"

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      {:error, :not_found} -> render(conn, :show, error_message: @err_msg)
      {:ok, user} -> Authentication.log_in_user(conn, user, user_params)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso")
    |> Authentication.log_out_user()
  end
end
