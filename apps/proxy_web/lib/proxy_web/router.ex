defmodule ProxyWeb.Router do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    endpoint = forward_conn(conn.path_info)
    endpoint.call(conn, [])
  end

  defp forward_conn(["api" | _]), do: PlataformaDigitalAPI.Endpoint
  defp forward_conn(["design-system" | _]), do: DesignSystem.Endpoint
  defp forward_conn(["storybook" | _]), do: DesignSystem.Endpoint
  defp forward_conn(_), do: PlataformaDigital.Endpoint
end
