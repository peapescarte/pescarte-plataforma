defmodule FuschiaWeb.UserAgent do
  @moduledoc false

  @doc """
  Get the user-agent request header
  """
  @spec get(Plug.Conn.t()) :: String.t()
  def get(conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> List.first()
  end
end
