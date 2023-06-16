defmodule PescarteWeb.GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  alias Pescarte.Domains.Accounts
  alias Pescarte.Repo

  @token_salt "autenticação de usuário"
  @day_seconds 86_400
  @endpoint PescarteWeb.Endpoint

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: Repo.preload(current_user, [:pesquisador])}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(@endpoint, @token_salt, token, max_age: @day_seconds) do
      Accounts.fetch_user_by_id(user_id)
    end
  end
end
