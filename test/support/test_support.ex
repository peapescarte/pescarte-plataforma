defmodule CoreWeb.TestSupport do
  @moduledoc """
  Handles support functions for tests
  """
  import Plug.Conn

  alias Fuschia.Context.ApiKeys
  alias Fuschia.Entities.{ApiKey, User}
  alias FuschiaWeb.Auth.Guardian

  @doc """
  Logs-in an user, requires an email and a matching password for tests
  """
  @spec login(%Plug.Conn{}, %User{}) :: %Plug.Conn{}
  def login(conn, user) do
    params = %{"cpf" => user.cpf, "password" => user.password}

    with {:ok, token} <- Guardian.authenticate(params),
         {:ok, _user} <- Guardian.user_claims(params) do
      put_req_header(conn, "authorization", "Bearer #{token}")
    else
      _ -> {:error, "Couldn't login"}
    end
  end

  @doc """
  Gets the api key for logging in
  """
  @spec get_api_key :: String.t() | {atom, String.t()}
  def get_api_key do
    case ApiKeys.one() do
      %ApiKey{} = api_key ->
        api_key.key

      nil ->
        {:error, "No API key"}
    end
  end
end
