defmodule PescarteWeb.GraphQL.Context do
  @behaviour Plug

  @day_seconds 86_400
  @endpoint PescarteWeb.Endpoint

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
    with {:ok, user_id} <-
           Phoenix.Token.verify(@endpoint, "user auth", token, max_age: @day_seconds) do
      case Accounts.get_user_by_id(user_id) do
        nil -> :error
        user -> {:ok, user}
      end
    end
  end
end
