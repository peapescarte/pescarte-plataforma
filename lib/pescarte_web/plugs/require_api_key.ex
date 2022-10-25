defmodule PescarteWeb.RequireApiKeyPlug do
  @moduledoc """
  Plug to handle the API key for
  header or query parameter
  """

  import Plug.Conn

  alias Pescarte.Accounts.Models.ApiKey
  alias Pescarte.Database

  @spec init(map) :: map
  def init(options), do: options

  @spec call(Plug.Conn.t(), map) :: Plug.Conn.t()
  def call(conn, _opts) do
    conn = fetch_query_params(conn)
    api_key = conn.query_params["api_key"] || conn |> get_req_header("x-api-key") |> List.first()

    case api_key && Database.get_by(ApiKey, key: api_key) do
      nil ->
        conn
        |> send_resp(
          :unauthorized,
          "You need a valid API Key to access this endpoint"
        )
        |> halt()

      _api_key ->
        conn
    end
  end
end
