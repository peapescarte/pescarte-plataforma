defmodule PescarteWeb.UserRegistrationController do
  @moduledoc false

  use PescarteWeb, :controller

  alias Pescarte.Accounts
  alias Pescarte.Accounts.Models.User
  alias PescarteWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_model" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, user} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/app/confirmar/#{&1}")
          )

        conn
        |> put_flash(:info, "Registration went successfully")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
