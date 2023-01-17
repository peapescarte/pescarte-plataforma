defmodule Pescarte.AccountsTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Accounts
  alias Pescarte.Accounts.Models.AuthLog
  alias Pescarte.Accounts.Models.User, as: UserModel
  alias Pescarte.Accounts.Models.UserToken
  alias Pescarte.Accounts.Queries.User, as: UserQueries
  alias Pescarte.Database
  alias Pescarte.Repo

  @moduletag :integration

  @ip "127.0.0.1"

  describe "list_user/1" do
    test "return all users in database" do
      user = user_fixture()

      assert [user] == Accounts.list_user()
    end
  end

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{cpf: cpf} = user = user_fixture()
      assert %UserModel{cpf: ^cpf} = Accounts.get_user_by_email(user.contato.email)
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture()
      refute Accounts.get_user_by_email_and_password(user.contato.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{cpf: cpf} = user = user_fixture()

      assert %UserModel{cpf: ^cpf} =
               Accounts.get_user_by_email_and_password(user.contato.email, valid_user_password())
    end
  end

  describe "user_exists?/1" do
    test "when id is valid, returns true" do
      user = insert(:user)
      assert Accounts.user_exists?(user.cpf)
    end

    test "when id is invalid, returns false" do
      refute Accounts.user_exists?("")
    end
  end

  describe "get_user/1" do
    test "when id is valid, returns a user" do
      user = user_fixture()
      assert user == Accounts.get_user(user.cpf)
    end

    test "when id is invalid, returns nil" do
      refute Accounts.get_user("")
    end
  end

  describe "get_user_by_id/1" do
    test "when id is valid, returns a user" do
      user = user_fixture()
      assert user == Accounts.get_user_by_id(user.id)
    end

    test "when id is invalid, returns nil" do
      refute Accounts.get_user_by_id("")
    end
  end

  describe "register_user/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               password: ["can't be blank"],
               contato: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} =
        Accounts.register_user(%{contato: %{email: "not valid"}, password: "not valid"})

      assert %{
               contato: %{email: ["must have the @ sign and no spaces"]},
               password: [
                 "at least one digit or punctuation character",
                 "at least one upper case character",
                 "should be at least 12 character(s)"
               ]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.register_user(%{contato: %{email: too_long}, password: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).contato.email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{contato: %{email: email}} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{contato: %{email: email}})
      assert "has already been taken" in errors_on(changeset).contato.email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{contato: %{email: String.upcase(email)}})
      assert "has already been taken" in errors_on(changeset).contato.email
    end

    test "registers user with a hashed password" do
      email = unique_user_email()
      contato = params_for(:contato, email: email)
      password = valid_user_password()

      valid_user_attributes =
        :user
        |> params_for()
        |> Map.put(:contato, contato)
        |> Map.merge(%{password: password, password_confirmation: password})

      {:ok, user} = Accounts.register_user(valid_user_attributes)
      assert user.contato.email == email
      assert is_binary(user.password_hash)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%UserModel{})
      assert changeset.required == ~w(password contato nome_completo cpf data_nascimento)a
    end

    test "allows fields to be set" do
      email = unique_user_email()
      password = valid_user_password()

      contato = params_for(:contato, email: email)

      valid_user_attributes =
        :user
        |> params_for()
        |> Map.put(:contato, contato)
        |> Map.merge(%{password: password, password_confirmation: password})

      changeset =
        Accounts.change_user_registration(
          %UserModel{},
          valid_user_attributes
        )

      assert changeset.valid?
      assert changeset |> get_change(:contato) |> get_change(:email) == email
      assert get_change(changeset, :password) == password
      refute get_change(changeset, :password_hash)
    end
  end

  describe "change_user_email/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} =
               changeset =
               %UserModel{}
               |> Database.preload_all(UserQueries.relationships())
               |> Accounts.change_user_email()

      assert :contato in changeset.required
    end
  end

  describe "apply_user_email/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} = Accounts.apply_user_email(user, valid_user_password(), %{})
      assert %{email: ["didn't change"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, valid_user_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_user_email(user, valid_user_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{user: user} do
      %{contato: %{email: email}} = user_fixture()

      {:error, changeset} =
        Accounts.apply_user_email(user, valid_user_password(), %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, "invalid", %{email: unique_user_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{user: user} do
      email = unique_user_email()
      {:ok, user} = Accounts.apply_user_email(user, valid_user_password(), %{email: email})
      assert user.contato.email == email
      assert Accounts.get_user(user.cpf).contato.email != email
    end
  end

  describe "deliver_update_email_instructions/3" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(user, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_cpf == user.cpf
      assert user_token.sent_to == user.contato.email
      assert user_token.context == "change:current@example.com"
    end
  end

  describe "update_user_email/2" do
    setup do
      user = user_fixture()
      email = unique_user_email()

      contato = user.contato |> Map.delete([:id, :__struct__]) |> Map.put(:email, email)

      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_email_instructions(
            %{user | contato: contato},
            user.contato.email,
            url
          )
        end)

      %{user: user, token: token, email: email}
    end

    test "updates the email with a valid token", %{user: user, token: token, email: email} do
      assert Accounts.update_user_email(user, token) == :ok
      changed_user = Accounts.get_user(user.cpf)
      assert changed_user.contato.email != user.contato.email
      assert changed_user.contato.email == email
      assert changed_user.confirmed_at
      assert changed_user.confirmed_at != user.confirmed_at
      refute Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not update email with invalid token", %{user: user} do
      assert Accounts.update_user_email(user, "oops") == :error
      assert Accounts.get_user(user.cpf).contato.email == user.contato.email
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not update email if user email changed", %{user: user, token: token} do
      contato = %{user.contato | email: "current@example.com"}
      assert Accounts.update_user_email(%{user | contato: contato}, token) == :error
      assert Accounts.get_user(user.cpf).contato.email == user.contato.email
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not update email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.update_user_email(user, token) == :error
      assert Accounts.get_user(user.cpf).contato.email == user.contato.email
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%UserModel{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_user_password(%UserModel{}, %{
          "password" => "New valid password!",
          "password_confirmation" => "New valid password!"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "New valid password!"
      refute get_change(changeset, :password_hash)
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: [
                 "at least one digit or punctuation character",
                 "at least one upper case character",
                 "should be at least 12 character(s)"
               ],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, "invalid", %{password: valid_user_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "New valid password!",
          password_confirmation: "New valid password!"
        })

      assert is_nil(user.password)
      assert Accounts.get_user_by_email_and_password(user.contato.email, "New valid password!")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)

      {:ok, _} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "New valid password!",
          password_confirmation: "New valid password!"
        })

      refute Repo.get_by(UserToken, user_cpf: user.cpf)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: insert(:user)}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_cpf: user_fixture().cpf,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = insert(:user)
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.cpf == user.cpf
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = insert(:user)
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_confirmation_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_cpf == user.cpf
      assert user_token.sent_to == user.contato.email
      assert user_token.context == "confirm"
    end
  end

  describe "confirm_user/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "confirms the email with a valid token", %{user: user, token: token} do
      assert {:ok, confirmed_user} = Accounts.confirm_user(token)
      assert confirmed_user.confirmed_at
      assert confirmed_user.confirmed_at != user.confirmed_at
      assert Repo.get!(UserModel, user.cpf).confirmed_at
      refute Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not confirm with invalid token", %{user: user} do
      assert Accounts.confirm_user("oops") == :error
      refute Repo.get!(UserModel, user.cpf).confirmed_at
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not confirm email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.confirm_user(token) == :error
      refute Repo.get!(UserModel, user.cpf).confirmed_at
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_cpf == user.cpf
      assert user_token.sent_to == user.contato.email
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "returns the user with valid token", %{user: %{cpf: cpf}, token: token} do
      assert %UserModel{cpf: ^cpf} = Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_cpf: cpf)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Accounts.get_user_by_reset_password_token("oops")
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_cpf: user.cpf)
    end
  end

  describe "reset_user_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.reset_user_password(user, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: [
                 "at least one digit or punctuation character",
                 "at least one upper case character",
                 "should be at least 12 character(s)"
               ],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.reset_user_password(user, %{password: too_long})
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{user: user} do
      {:ok, updated_user} =
        Accounts.reset_user_password(user, %{
          password: "New valid password!",
          password_confirmation: "New valid password!"
        })

      assert is_nil(updated_user.password)
      assert Accounts.get_user_by_email_and_password(user.contato.email, "New valid password!")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)

      {:ok, _} =
        Accounts.reset_user_password(user, %{
          password: "New valid password!",
          password_confirmation: "New valid password!"
        })

      refute Repo.get_by(UserToken, user_cpf: user.cpf)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%UserModel{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "create_auth_log/1" do
    test "success should return :ok" do
      ua =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

      user = insert(:user)

      result =
        Accounts.create_auth_log(%{"ip" => @ip, "user_agent" => ua, "user_cpf" => user.cpf})

      auth_log = get_log(@ip)

      assert result == :ok
      assert Map.get(auth_log, :ip) == @ip
      assert Map.get(auth_log, :user_agent) == ua
      assert Map.get(auth_log, :user_cpf) == user.cpf
    end

    test "with error should return :ok" do
      user = build(:user)
      result = Accounts.create_auth_log(%{"user_cpf" => user})
      auth_log = get_log(@ip)

      assert result == :ok
      assert auth_log == nil
    end
  end

  describe "create_auth_log/3" do
    test "success should return :ok" do
      ua =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

      user = insert(:user)

      result = Accounts.create_auth_log(@ip, ua, user)
      auth_log = get_log(@ip)

      assert result == :ok
      assert Map.get(auth_log, :ip) == @ip
      assert Map.get(auth_log, :user_agent) == ua
      assert Map.get(auth_log, :user_cpf) == user.cpf
    end

    test "with error should return :ok" do
      user = build(:user)
      result = Accounts.create_auth_log(nil, nil, user)
      auth_log = get_log(@ip)

      assert result == :ok
      assert auth_log == nil
    end
  end

  defp get_log(ip) do
    Repo.get_by(AuthLog, ip: ip)
  end
end
