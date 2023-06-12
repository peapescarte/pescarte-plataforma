defmodule Pescarte.Accounts.AccountsTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken

  import Pescarte.Factory

  @moduletag :unit

  @now NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  describe "confirm_user/1" do
    test "quando o token de confirmação é inválido" do
      assert {:error, :invalid_token} = Accounts.confirm_user("um token", @now)
    end

    test "quando o token de confirmação não existe para um usuário" do
      token = :crypto.strong_rand_bytes(32)
      insert(:email_token)
      confirm_token = Base.url_encode64(token)

      assert {:error, :not_found} = Accounts.confirm_user(confirm_token, @now)
    end

    test "quando o token de confirmação é válido" do
      user = Repo.preload(insert(:user), :contato)
      token = :crypto.strong_rand_bytes(32)
      hashed = :crypto.hash(:sha256, token)

      params = [
        contexto: "confirm",
        usuario_id: user.id,
        token: hashed,
        enviado_para: user.contato.email_principal
      ]

      insert(:email_token, params)
      confirm_token = Base.url_encode64(token)

      assert {:ok, confirmed} = Accounts.confirm_user(confirm_token, @now)
      assert confirmed.id == user.id
      assert confirmed.confirmado_em == @now
    end
  end

  describe "create_user" do
    test "quando os atributos são inválidos" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_admin(%{})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_pesquisador(%{})
    end

    test "quando os atributos são válidos" do
      assert {:ok, %User{}} =
               :user_creation
               |> build()
               |> Accounts.create_user_admin()

      assert {:ok, %User{}} =
               :user_creation
               |> build()
               |> Accounts.create_user_pesquisador()
    end
  end

  describe "fetch_user_by_cpf_and_password/2" do
    test "quando o cpf ou a senha sãos inválidos" do
      user = insert(:user)

      assert {:error, :not_found} = Accounts.fetch_user_by_cpf_and_password("123", user.senha)

      assert {:error, :invalid_password} =
               Accounts.fetch_user_by_cpf_and_password(user.cpf, "123")
    end

    test "quando o cpf e a senha são válidos" do
      user = insert(:user)

      assert {:ok, fetched} = Accounts.fetch_user_by_cpf_and_password(user.cpf, user.senha)
      assert fetched.id == user.id
      assert fetched.cpf == user.cpf
    end
  end

  describe "fetch_user_by_email_and_password/2" do
    test "quando o email ou a senha sãos inválidos" do
      user = Repo.preload(insert(:user), :contato)

      assert {:error, :not_found} = Accounts.fetch_user_by_email_and_password("123", user.senha)

      assert {:error, :invalid_password} =
               Accounts.fetch_user_by_email_and_password(user.contato.email_principal, "123")
    end

    test "quando o email e a senha são válidos" do
      user = Repo.preload(insert(:user), :contato)

      assert {:ok, fetched} =
               Accounts.fetch_user_by_email_and_password(user.contato.email_principal, user.senha)

      assert fetched.id == user.id
      assert fetched.cpf == user.cpf
    end
  end

  describe "fetch_user_by_reset_password_token/1" do
    test "quando o token é inválido" do
      assert {:error, :invalid_token} =
               Accounts.fetch_user_by_reset_password_token("token inválido")

      assert {:error, :not_found} =
               Accounts.fetch_user_by_reset_password_token(Base.url_encode64("token inválido"))
    end

    test "quando o token é valido para o usuário" do
      user = Repo.preload(insert(:user), :contato)
      token = :crypto.strong_rand_bytes(32)

      insert(:email_token,
        contexto: "reset_password",
        usuario: user,
        usuario_id: user.id,
        enviado_para: user.contato.email_principal,
        token: :crypto.hash(:sha256, token)
      )

      token_url_encoded = Base.url_encode64(token)
      assert {:ok, fetched} = Accounts.fetch_user_by_reset_password_token(token_url_encoded)
      assert user.id == fetched.id
    end
  end

  describe "fetch_user_by_session_token" do
    test "quando o token é inválido" do
      assert {:error, :not_found} = Accounts.fetch_user_by_session_token("token inválido")
    end

    test "quando o token é válido para o usuário" do
      token = Repo.preload(insert(:session_token), :usuario)
      user = Repo.preload(token.usuario, :contato)

      assert {:ok, fetched} = Accounts.fetch_user_by_session_token(token.token)
      assert fetched.id == user.id
    end
  end

  describe "generate_email_token/2" do
    test "quando o token gerado é válido, é possível recuperar o usuário" do
      user = Repo.preload(insert(:user), :contato)

      assert {:ok, token} = Accounts.generate_email_token(user, "reset_password")
      assert {:ok, fetched} = Accounts.fetch_user_by_reset_password_token(token)
      assert fetched.id == user.id
    end
  end

  describe "generate_session_token/1" do
    test "quando o token gerado é válido, é possível recuperar o usuário" do
      user = Repo.preload(insert(:user), :contato)

      assert {:ok, token} = Accounts.generate_session_token(user)
      assert {:ok, fetched} = Accounts.fetch_user_by_session_token(token)
      assert fetched.id == user.id
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: Repo.preload(insert(:user), :contato)}
    end

    test "quando a senha atual for incorreta", ctx do
      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = Accounts.update_user_password(ctx.user, "incorreta", %{})
    end

    test "quando as novas senhas forem inválidas", ctx do
      senhas = %{senha: "123", senha_confirmation: "123"}
      atual = senha_atual()

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = Accounts.update_user_password(ctx.user, atual, senhas)
    end

    test "quando a atual é válida e as senhas novas são iguais a atual", ctx do
      atual = senha_atual()
      senhas = %{senha: atual, senha_confirmation: atual}

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = Accounts.update_user_password(ctx.user, atual, senhas)
      assert changed.hash_senha == ctx.user.hash_senha
      assert Repo.aggregate(UserToken, :count) == 0
    end

    test "quando a senha atual e as senhas novas forem válidas", ctx do
      atual = senha_atual()
      senhas = %{senha: "pASSw0rd!234", senha_confirmation: "pASSw0rd!234"}

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = Accounts.update_user_password(ctx.user, atual, senhas)
      assert changed.hash_senha != ctx.user.hash_senha
      assert Repo.aggregate(UserToken, :count) == 0
    end
  end

  describe "reset_user_password/2" do
    setup do
      %{user: Repo.preload(insert(:user), :contato)}
    end

    test "quando as novas senhas são inválidas", ctx do
      senhas = %{senha: "123", senha_confirmation: "123"}

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = Accounts.reset_user_password(ctx.user, senhas)
    end

    test "quando as senhas novas são iguais a atual", ctx do
      atual = senha_atual()
      senhas = %{senha: atual, senha_confirmation: atual}

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = Accounts.reset_user_password(ctx.user, senhas)
      assert changed.hash_senha == ctx.user.hash_senha
      assert Repo.aggregate(UserToken, :count) == 0
    end

    test "quando as senhas novas são válidas", ctx do
      senhas = %{senha: "pASSw0rd!234", senha_confirmation: "pASSw0rd!234"}

      assert {:ok, _token} = Accounts.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = Accounts.reset_user_password(ctx.user, senhas)
      assert changed.hash_senha != ctx.user.hash_senha
      assert Repo.aggregate(UserToken, :count) == 0
    end
  end
end
