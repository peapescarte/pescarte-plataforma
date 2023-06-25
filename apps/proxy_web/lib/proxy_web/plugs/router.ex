defmodule ProxyWeb.Router do
  @behaviour Plug

  def init(routes), do: routes

  def call(conn, routes) do
    endpoint = forward_conn(conn.path_info, routes)
    endpoint.call(conn, endpoint.init(nil))
  end

  defp forward_conn(["api" | _], %{api: endpoint}), do: endpoint
  defp forward_conn(_, %{default: endpoint}), do: endpoint
end
