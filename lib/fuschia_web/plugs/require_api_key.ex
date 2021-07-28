defmodule FuschiaWeb.RequireApiKeyPlug do
  @moduledoc """
  Plug to handle the API key for
  header or query parameter
  """

  import Plug.Conn
  import FuschiaWeb.Gettext

  alias Fuschia.Context.ApiKeys

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)
    api_key = conn.query_params["api_key"] || get_req_header(conn, "x-api-key") |> List.first()

    case api_key && ApiKeys.one_by_key(api_key) do
      nil ->
        send_resp(
          conn,
          :unauthorized,
          gettext("You need a valid API Key to access this endpoint")
        )
        |> halt()

      _ ->
        conn
    end
  end
end
