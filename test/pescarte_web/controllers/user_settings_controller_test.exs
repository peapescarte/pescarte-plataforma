defmodule PescarteWeb.UserSettingsControllerTest do
  use PescarteWeb.ConnCase, async: true

  alias Pescarte.Accounts

  import Pescarte.Factory

  @moduletag :integration

  setup :register_and_log_in_user

  describe "GET /usuarios/:user_id/configuracoes" do
    test "renders settings page", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_settings_path(conn, :edit, user.id))
      assert _response = html_response(conn, 200)
      # TODO
      # assert response =~ "<h1>Settings</h1>"
    end

    test "redirects if user is not logged in", %{user: user} do
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :edit, user.id))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  describe "PUT /usuarios/:user_id/configuracoes (change password form)" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, Routes.user_settings_path(conn, :update, user.id), %{
          "action" => "update_password",
          "current_password" => valid_user_password(),
          "user" => %{
            "password" => "New valid password!",
            "password_confirmation" => "New valid password!"
          }
        })

      assert redirected_to(new_password_conn) == Routes.user_settings_path(conn, :edit, user.id)
      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_user_by_email_and_password(user.contato.email, "New valid password!")
    end

    test "does not update password on invalid data", %{conn: conn, user: user} do
      old_password_conn =
        put(conn, Routes.user_settings_path(conn, :update, user.id), %{
          "action" => "update_password",
          "current_password" => "invalid",
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert _response = html_response(old_password_conn, 200)
      # TODO
      # assert response =~ "<h1>Settings</h1>"
      # assert response =~ "should be at least 12 character(s)"
      # assert response =~ "does not match password"
      # assert response =~ "is not valid"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end

  describe "PUT /usuarios/:user_id/configuracoes (change email form)" do
    @tag :capture_log
    test "updates the user email", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.user_settings_path(conn, :update, user.id), %{
          "action" => "update_email",
          "current_password" => valid_user_password(),
          "contato" => %{"email" => unique_user_email()}
        })

      assert redirected_to(conn) == Routes.user_settings_path(conn, :edit, user.id)
      assert get_flash(conn, :info) =~ "A link to confirm your email"
      assert Accounts.get_user_by_email(user.contato.email)
    end

    test "does not update email on invalid data", %{conn: conn, user: user} do
      conn =
        put(conn, Routes.user_settings_path(conn, :update, user.id), %{
          "action" => "update_email",
          "current_password" => "invalid",
          "contato" => %{"email" => "with spaces"}
        })

      assert _response = html_response(conn, 200)
      # TODO
      # assert response =~ "<h1>Settings</h1>"
      # assert response =~ "must have the @ sign and no spaces"
      # assert response =~ "is not valid"
    end
  end

  describe "GET /usuarios/:user_id/configuracoes/confirmar_email/:token" do
    setup %{user: user} do
      email = unique_user_email()

      contact = %{user.contato | email: email}

      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(
            %{user | contato: contact},
            user.contato.email,
            url
          )
        end)

      %{token: token, email: email}
    end

    test "updates the user email once", %{conn: conn, user: user, token: token, email: email} do
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, user.id, token))
      assert redirected_to(conn) == Routes.user_settings_path(conn, :edit, user.id)
      assert get_flash(conn, :info) =~ "Email changed successfully"
      refute Accounts.get_user_by_email(user.contato.email)
      assert Accounts.get_user_by_email(email)

      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, user.id, token))
      assert redirected_to(conn) == Routes.user_settings_path(conn, :edit, user.id)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
    end

    test "does not update email with invalid token", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, user.id, "oops"))
      assert redirected_to(conn) == Routes.user_settings_path(conn, :edit, user.id)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
      assert Accounts.get_user_by_email(user.contato.email)
    end

    test "redirects if user is not logged in", %{token: token, user: user} do
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :confirm_email, user.id, token))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end
end
