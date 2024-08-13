defmodule Pescarte.Clients.Auth do
  use PescarteWeb, :verified_routes

  alias Pescarte.Clients.Auth.User

  @behaviour Pescarte.Clients.Auth.Behaviour

  @client Application.compile_env!(:pescarte, [Pescarte.Clients, :auth])

  @impl true
  def create_user(params) do
    with {:ok, params} <- User.create_schema(params),
         {:ok, user} <- @client.create_user(params) do
      User.from_external(user)
    end
  end

  @impl true
  def update_user(id, params) do
    with {:ok, user} <- @client.update_user(id, params) do
      User.from_external(user)
    end
  end

  @impl true
  defdelegate delete_user(id), to: @client

  @impl true
  def get_user(id) do
    with {:ok, user} <- @client.get_user(id) do
      User.from_external(user)
    end
  end

  @impl true
  def authenticate(%{email: _, password: _} = params) do
    with {:ok, session} <- @client.authenticate(params) do
      User.from_session(session)
    end
  end

  @impl true
  defdelegate sign_out(token, scope), to: @client

  def resend_confirmation_email(email) do
  	@client.resend_confirmation_email(email, :signup, ~p"/confirmar")
  end
end
