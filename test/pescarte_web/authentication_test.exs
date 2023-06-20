defmodule PescarteWeb.AuthenticationTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.AccountsFixtures

  alias Pescarte.Domains.Accounts
  alias PescarteWeb.Authentication
  alias PescarteWeb.Endpoint

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{user: user_fixture(), conn: conn}
  end

  describe "log_in_user/3" do
    test "armazena o token do usuário na sessão", %{conn: conn, user: user} do
      conn = Authentication.log_in_user(conn, user)

      assert token = get_session(conn, :user_token)
      assert get_session(conn, :live_socket_id) == "users_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == ~p"/app/pesquisa/perfil"
      assert Accounts.fetch_user_by_session_token(token)
    end
  end
end
