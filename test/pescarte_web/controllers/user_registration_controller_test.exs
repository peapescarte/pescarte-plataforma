defmodule PescarteWeb.UserRegistrationControllerTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Factory

  @moduletag :integration

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, PescarteWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{conn: conn}
  end

  describe "GET /cadastrar" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      assert _response = html_response(conn, 200)
      # TODO
      # assert response =~ "<h1>Register</h1>"
      # assert response =~ "Log in</a>"
      # assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> put_session(:user_return_to, "/app/pesquisadores/#{user.id}")
        |> log_in_user(user)
        |> get(Routes.user_registration_path(conn, :new))

      assert redirected_to(conn) == "/app/pesquisadores/#{user.id}"
    end
  end

  describe "POST /cadastrar" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()
      contact = params_for(:contato, email: email)
      password = valid_user_password()

      valid_user_attributes =
        :user
        |> params_for()
        |> Map.put(:contato, contact)
        |> Map.merge(%{password: password, password_confirmation: password})

      conn =
        conn
        |> put_session(:user_return_to, "/app/pesquisadores/#{valid_user_attributes.id}")
        |> post(Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/app/pesquisadores/#{valid_user_attributes.id}"

      # Now do a logged in request and assert on the menu
      # TODO
      # conn = get(conn, "/")
      # response = html_response(conn, 200)
      # assert response =~ email
      # assert response =~ "Settings</a>"
      # assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      assert _response = html_response(conn, 200)
      # TODO
      # assert response =~ "<h1>Register</h1>"
      # assert response =~ "must have the @ sign and no spaces"
      # assert response =~ "should be at least 12 character"
    end
  end
end
