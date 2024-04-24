defmodule PescarteWeb.GraphQL.Context do
  @behaviour Plug

  import Plug.Conn

  alias Pescarte.Identidades.Models.Usuario

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    if Pescarte.env() == :test do
      Usuario.fetch_by(id: token)
    else
      session = %Supabase.GoTrue.Session{access_token: token}

      with {:ok, user} <- Pescarte.Supabase.Auth.get_user(session) do
        Usuario.fetch_by(external_customer_id: user.id)
      end
    end
  end
end
