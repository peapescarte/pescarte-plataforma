defmodule PlataformaDigital.HealthCheck do
  @moduledoc """
  Plug to handle the API Health Check.
  """
  import Plug.Conn

  def init(options), do: options

  def call(%Plug.Conn{request_path: "/health-check"} = conn, _opts) do
    conn
    |> send_resp(200, "")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
