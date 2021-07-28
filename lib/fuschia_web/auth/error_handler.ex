defmodule FuschiaWeb.Auth.ErrorHandler do
  @moduledoc """
  Error Handler for Fuschia Auth
  """

  import Plug.Conn, only: [send_resp: 3]

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})

    send_resp(conn, :unauthorized, body)
  end
end
