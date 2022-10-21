defmodule BackendWeb.UserSessionControllerTest do
  use BackendWeb.ConnCase, async: true

  import Backend.Factory

  @moduletag :integration

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, BackendWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{user: user_fixture(), conn: conn}
  end

  describe "GET /acessar" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Register</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      assert redirected_to(conn) == "/app/pesquisadores/#{user.id}"
    end
  end

  describe "POST /acessar" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        conn
        |> put_session(:user_return_to, "/app/usuarios/#{user.id}")
        |> post(Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.contato.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/app/usuarios/#{user.id}"

      # Now do a logged in request and assert on the menu
      # TODO
      # conn = get(conn, "/")
      # response = html_response(conn, 200)
      # assert response =~ user.email
      # assert response =~ "Settings</a>"
      # assert response =~ "Log out</a>"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        conn
        |> put_session(:user_return_to, "/app/usuarios/#{user.id}")
        |> post(Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.contato.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_backend_web_user_remember_me"]
      assert redirected_to(conn) == "/app/usuarios/#{user.id}"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.contato.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.contato.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /user/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
