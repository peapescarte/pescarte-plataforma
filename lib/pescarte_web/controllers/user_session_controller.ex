defmodule BackendWeb.UserSessionController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias BackendWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"cpf" => cpf, "password" => password} = user_params

    case Accounts.get_user_by_cpf_and_password(cpf, password) do
      {:ok, user} -> UserAuth.log_in_user(conn, user, user_params)
      # Para evitar ataques de enumeração de usuários, não divulgue se o email está registrado.
      {:error, :not_found} -> render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
