defmodule PescarteWeb.AuthenticationTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Identidades.Handlers.CredenciaisHandler
  alias PescarteWeb.Authentication
  alias Phoenix.LiveView

  @remember_me_cookie "_pescarte_web_user_remember_me"

  setup %{conn: conn} do
    conn = init_test_session(conn, %{})
    %{user: insert(:usuario), conn: conn}
  end

  describe "log_in_user/3" do
    test "armazena o token do usuário na sessão", %{conn: conn, user: user} do
      conn = Authentication.log_in_user(conn, user)

      assert token = get_session(conn, :user_token)
      assert get_session(conn, :live_socket_id) == "users_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == ~p"/app/pesquisa/perfil"
      assert {:ok, _user} = CredenciaisHandler.fetch_usuario_by_session_token(token)
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
      {:ok, user_token} = CredenciaisHandler.generate_session_token(user)

      conn =
        conn
        |> put_session(:user_token, user_token)
        |> put_resp_cookie(@remember_me_cookie, user_token)
        |> fetch_cookies()
        |> Authentication.log_out_user()

      refute get_session(conn, :user_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == ~p"/"
      assert {:error, :not_found} = CredenciaisHandler.fetch_usuario_by_session_token(user_token)
    end

    test "transmite para o live_socket_id fornecido", %{conn: conn} do
      live_socket_id = "users_sessions:abcdefg123-token"
      @endpoint.subscribe(live_socket_id)

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

  describe "fetch_current_user/2" do
    test "autentica sessão atual", %{conn: conn, user: user} do
      {:ok, user_token} = CredenciaisHandler.generate_session_token(user)

      conn =
        conn
        |> put_session(:user_token, user_token)
        |> Authentication.fetch_current_user([])

      assert conn.assigns.current_user.id == user.id
    end

    test "autentica o usuário a partir dos cookies", %{conn: conn, user: user} do
      logged_in_conn =
        conn
        |> fetch_cookies()
        |> Authentication.log_in_user(user, %{"remember_me" => "true"})

      user_token = logged_in_conn.cookies[@remember_me_cookie]
      %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]

      conn =
        conn
        |> put_req_cookie(@remember_me_cookie, signed_token)
        |> Authentication.fetch_current_user([])

      assert conn.assigns.current_user.id == user.id
      assert get_session(conn, :user_token) == user_token

      assert get_session(conn, :live_socket_id) ==
               "users_sessions:#{Base.url_encode64(user_token)}"
    end

    test "não autentica se estiver faltando dados", %{conn: conn} do
      conn = Authentication.fetch_current_user(conn, [])

      refute get_session(conn, :user_token)
      refute conn.assigns.current_user
    end
  end

  describe "on_mount: :mount_current_user" do
    test "se o token for valido, atribui o User a current_user", %{conn: conn, user: user} do
      {:ok, user_token} = CredenciaisHandler.generate_session_token(user)

      session =
        conn
        |> put_session(:user_token, user_token)
        |> get_session()

      {:cont, updated_socket} =
        Authentication.on_mount(:mount_current_user, %{}, session, %LiveView.Socket{})

      assert updated_socket.assigns.current_user.id == user.id
    end

    test "se o token for invalido, atribui nil a current_user", %{conn: conn} do
      user_token = "invalid_token"

      session =
        conn
        |> put_session(:user_token, user_token)
        |> get_session()

      {:cont, updated_socket} =
        Authentication.on_mount(:mount_current_user, %{}, session, %LiveView.Socket{})

      refute updated_socket.assigns.current_user
    end

    test "se o token não existir, atribui nil a current_user", %{conn: conn} do
      session = get_session(conn)

      {:cont, updated_socket} =
        Authentication.on_mount(:mount_current_user, %{}, session, %LiveView.Socket{})

      refute updated_socket.assigns.current_user
    end
  end

  describe "on_mount: :redirect_if_user_is_authenticated" do
    test "redireciona se existir um usuário autenticado", %{conn: conn, user: user} do
      {:ok, user_token} = CredenciaisHandler.generate_session_token(user)

      session =
        conn
        |> put_session(:user_token, user_token)
        |> get_session()

      assert {:halt, _updated_socket} =
               Authentication.on_mount(
                 :redirect_if_user_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end

    test "não redireciona se o usuário não estiver autenticado", %{conn: conn} do
      session = get_session(conn)

      assert {:cont, _updated_socket} =
               Authentication.on_mount(
                 :redirect_if_user_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end
  end

  describe "redirect_if_user_is_authenticated/2" do
    test "redireciona se o usuário estiver autenticado", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> Authentication.redirect_if_user_is_authenticated([])

      assert conn.halted
      assert redirected_to(conn) == ~p"/app/pesquisa/perfil"
    end

    test "não redireciona se o usuário não estiver autenticado", %{conn: conn} do
      conn = Authentication.redirect_if_user_is_authenticated(conn, [])

      refute conn.halted
      refute conn.status
    end
  end

  describe "require_authenticated_user/2" do
    test "redireciona se o usuário não estiver autenticado", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> Authentication.require_authenticated_user([])

      assert conn.halted
      assert redirected_to(conn) == ~p"/acessar"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You must log in to access this page."
    end

    test "armazena o path para redirecionar com GET", %{conn: conn} do
      conn_without_query =
        %{conn | path_info: ["test"], query_string: ""}
        |> fetch_flash()
        |> Authentication.require_authenticated_user([])

      assert conn_without_query.halted
      assert get_session(conn_without_query, :user_return_to) == "/test"

      conn_with_query =
        %{conn | path_info: ["test"], query_string: "query=test"}
        |> fetch_flash()
        |> Authentication.require_authenticated_user([])

      assert conn_with_query.halted
      assert get_session(conn_with_query, :user_return_to) == "/test?query=test"

      conn_post =
        %{conn | path_info: ["test"], query_string: "query", method: "POST"}
        |> fetch_flash()
        |> Authentication.require_authenticated_user([])

      assert conn_post.halted
      refute get_session(conn_post, :user_return_to)
    end

    test "não redireciona se o usuário está autenticado", %{conn: conn, user: user} do
      conn =
        conn
        |> assign(:current_user, user)
        |> Authentication.require_authenticated_user([])

      refute conn.halted
      refute conn.status
    end
  end
end
