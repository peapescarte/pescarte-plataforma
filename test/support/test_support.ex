defmodule CoreWeb.TestSupport do
  @moduledoc """
  Handles support functions for tests
  """
  import Plug.Conn

  alias Fuschia.Accounts.Models.ApiKey, as: ApiKeyModel
  alias Fuschia.Accounts.Queries.ApiKey, as: ApiKeyQueries
  alias Fuschia.Database
  alias FuschiaWeb.Auth.Guardian

  @doc """
  Logs-in an user, requires an email and a matching password for tests
  """
  @spec login(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
  def login(conn, user) do
    params = %{"cpf" => user.cpf, "password" => user.password}

    with {:ok, token} <- Guardian.authenticate(params),
         {:ok, _user} <- Guardian.user_claims(params) do
      put_req_header(conn, "authorization", "Bearer #{token}")
    else
      _err -> {:error, "Couldn't login"}
    end
  end

  @doc """
  Gets the api key for logging in
  """
  @spec get_api_key :: String.t() | {atom, String.t()}
  def get_api_key do
    case Database.one(ApiKeyQueries.query()) do
      %ApiKeyModel{} = api_key ->
        api_key.key

      nil ->
        {:error, "No API key"}
    end
  end
end
