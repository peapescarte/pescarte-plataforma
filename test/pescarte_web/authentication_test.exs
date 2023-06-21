defmodule PescarteWeb.AuthenticationTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.Accounts
  alias PescarteWeb.Authentication
  alias PescarteWeb.Endpoint

  @remember_me_cookie "_pescarte_web_user_remember_me"

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{user: insert(:user), conn: conn}
  end

  describe "log_in_user/3" do
    test "armazena o token do usuário na sessão", %{conn: conn, user: user} do
      conn = Authentication.log_in_user(conn, user)

      assert token = get_session(conn, :user_token)
      assert get_session(conn, :live_socket_id) == "users_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == ~p"/app/pesquisa/perfil"
      assert Accounts.fetch_user_by_session_token(token)
    end

    test "limpa tudo previamente armazenado na sessão", %{conn: conn, user: user} do
      conn =
        conn
        |> put_session(:to_be_removed, "value")
        |> Authentication.log_in_user(user)

      refute get_session(conn, :to_be_removed)
    end

    test "redireciona para a rota configurada", %{conn: conn, user: user} do
      conn =
        conn
        |> put_session(:user_return_to, "/teste")
        |> Authentication.log_in_user(user)

      assert redirected_to(conn) == "/teste"
    end

    test "salva um cookie se o remember_me for marcado", %{conn: conn, user: user} do
      conn =
        conn
        |> fetch_cookies()
        |> Authentication.log_in_user(user, %{"remember_me" => "true"})

      assert get_session(conn, :user_token) == conn.cookies[@remember_me_cookie]

      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies[@remember_me_cookie]
      assert signed_token != get_session(conn, :user_token)
      assert max_age == 5_184_000
    end
  end

  describe "log_out_user/1" do
    test "limpa sessão e cookies", %{conn: conn, user: user} do
      {:ok, token} = Accounts.generate_session_token(user)

      conn =
        conn
        |> put_session(:user_token, token)
        |> put_resp_cookie(@remember_me_cookie, token)
        |> fetch_cookies()
        |> Authentication.log_out_user()

      refute get_session(conn, :user_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == ~p"/"
      assert {:error, :not_found} = Accounts.fetch_user_by_session_token(token)
    end

    test "transmite para o live_socket_id fornecido", %{conn: conn} do
      live_socket_id = "users_sessions:abcdefg123-token"
      Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> Authentication.log_out_user()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "funciona mesmo se o usuário já estiver desconectado", %{conn: conn} do
      conn =
        conn
        |> fetch_cookies()
        |> Authentication.log_out_user()

      refute get_session(conn, :user_token)
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == ~p"/"
    end
  end
end
