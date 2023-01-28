defmodule PescarteWeb.GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  alias Pescarte.Domains.Accounts.Models.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do

  end
end
