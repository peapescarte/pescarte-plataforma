defmodule PescarteWeb.GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  alias Pescarte.Database
  alias Pescarte.Domains.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: Database.preload(current_user, [:pesquisador])}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    with {:ok, user_id} <- Phoenix.Token.verify(PescarteWeb.Endpoint, "user auth", token) do
      case Accounts.get_user_by_id(user_id) do
        nil -> %{}
        user -> user
      end
    end
  end
end
