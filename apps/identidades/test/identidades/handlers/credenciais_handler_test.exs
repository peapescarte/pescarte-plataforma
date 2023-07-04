defmodule Identidades.Handlers.CredenciaisHandlerTest do
  use Database.DataCase, async: true

  import Identidades.Factory

  alias Identidades.Handlers.CredenciaisHandler
  alias Identidades.Models.Token

  @moduletag :unit

  @now NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  describe "confirm_usuario/1" do
    test "quando o token de confirmação é inválido" do
      assert {:error, :invalid_token} = CredenciaisHandler.confirm_usuario("um token", @now)
    end

    test "quando o token de confirmação não existe para um usuário" do
      token = :crypto.strong_rand_bytes(32)
      insert(:email_token)
      confirm_token = Base.url_encode64(token)

      assert {:error, :not_found} = CredenciaisHandler.confirm_usuario(confirm_token, @now)
    end

    test "quando o token de confirmação é válido" do
      user = Repo.preload(insert(:usuario), :contato)
      token = :crypto.strong_rand_bytes(32)
      hashed = :crypto.hash(:sha256, token)

      params = [
        contexto: "confirm",
        usuario_id: user.id_publico,
        token: hashed,
        enviado_para: user.contato.email_principal
      ]

      insert(:email_token, params)
      confirm_token = Base.url_encode64(token)

      assert {:ok, confirmed} = CredenciaisHandler.confirm_usuario(confirm_token, @now)
      assert confirmed.id_publico == user.id_publico
      assert confirmed.confirmado_em == @now
    end
  end

  describe "fetch_usuario_by_reset_password_token/1" do
    test "quando o token é inválido" do
      assert {:error, :invalid_token} =
               CredenciaisHandler.fetch_usuario_by_reset_password_token("token inválido")

      assert {:error, :not_found} =
               CredenciaisHandler.fetch_usuario_by_reset_password_token(
                 Base.url_encode64("token inválido")
               )
    end

    test "quando o token é valido para o usuário" do
      user = Repo.preload(insert(:usuario), :contato)
      token = :crypto.strong_rand_bytes(32)

      insert(:email_token,
        contexto: "reset_password",
        usuario: user,
        usuario_id: user.id_publico,
        enviado_para: user.contato.email_principal,
        token: :crypto.hash(:sha256, token)
      )

      token_url_encoded = Base.url_encode64(token)

      assert {:ok, fetched} =
               CredenciaisHandler.fetch_usuario_by_reset_password_token(token_url_encoded)

      assert user.id_publico == fetched.id_publico
    end
  end

  describe "fetch_usuario_by_session_token" do
    test "quando o token é inválido" do
      assert {:error, :not_found} =
               CredenciaisHandler.fetch_usuario_by_session_token("token inválido")
    end

    test "quando o token é válido para o usuário" do
      token = Repo.preload(insert(:session_token), :usuario)
      user = Repo.preload(token.usuario, :contato)

      assert {:ok, fetched} = CredenciaisHandler.fetch_usuario_by_session_token(token.token)
      assert fetched.id_publico == user.id_publico
    end
  end

  describe "generate_email_token/2" do
    test "quando o token gerado é válido, é possível recuperar o usuário" do
      user = Repo.preload(insert(:usuario), :contato)

      assert {:ok, token} = CredenciaisHandler.generate_email_token(user, "reset_password")
      assert {:ok, fetched} = CredenciaisHandler.fetch_usuario_by_reset_password_token(token)
      assert fetched.id_publico == user.id_publico
    end
  end

  describe "generate_session_token/1" do
    test "quando o token gerado é válido, é possível recuperar o usuário" do
      user = Repo.preload(insert(:usuario), :contato)

      assert {:ok, token} = CredenciaisHandler.generate_session_token(user)
      assert {:ok, fetched} = CredenciaisHandler.fetch_usuario_by_session_token(token)
      assert fetched.id_publico == user.id_publico
    end
  end

  describe "update_usuario_password/3" do
    setup do
      %{user: Repo.preload(insert(:usuario), :contato)}
    end

    test "quando a senha atual for incorreta", ctx do
      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = CredenciaisHandler.update_usuario_password(ctx.user, "incorreta", %{})
    end

    test "quando as novas senhas forem inválidas", ctx do
      senhas = %{senha: "123", senha_confirmation: "123"}
      atual = senha_atual()

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = CredenciaisHandler.update_usuario_password(ctx.user, atual, senhas)
    end

    test "quando a atual é válida e as senhas novas são iguais a atual", ctx do
      atual = senha_atual()
      senhas = %{senha: atual, senha_confirmation: atual}

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = CredenciaisHandler.update_usuario_password(ctx.user, atual, senhas)
      assert changed.hash_senha == ctx.user.hash_senha
      assert Repo.aggregate(Token, :count) == 0
    end

    test "quando a senha atual e as senhas novas forem válidas", ctx do
      atual = senha_atual()
      senhas = %{senha: "pASSw0rd!234", senha_confirmation: "pASSw0rd!234"}

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = CredenciaisHandler.update_usuario_password(ctx.user, atual, senhas)
      assert changed.hash_senha != ctx.user.hash_senha
      assert Repo.aggregate(Token, :count) == 0
    end
  end

  describe "reset_usuario_password/2" do
    setup do
      %{user: Repo.preload(insert(:usuario), :contato)}
    end

    test "quando as novas senhas são inválidas", ctx do
      senhas = %{senha: "123", senha_confirmation: "123"}

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:error, _} = CredenciaisHandler.reset_usuario_password(ctx.user, senhas)
    end

    test "quando as senhas novas são iguais a atual", ctx do
      atual = senha_atual()
      senhas = %{senha: atual, senha_confirmation: atual}

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = CredenciaisHandler.reset_usuario_password(ctx.user, senhas)
      assert changed.hash_senha == ctx.user.hash_senha
      assert Repo.aggregate(Token, :count) == 0
    end

    test "quando as senhas novas são válidas", ctx do
      senhas = %{senha: "pASSw0rd!234", senha_confirmation: "pASSw0rd!234"}

      assert {:ok, _token} = CredenciaisHandler.generate_email_token(ctx.user, "reset_password")
      assert {:ok, changed} = CredenciaisHandler.reset_usuario_password(ctx.user, senhas)
      assert changed.hash_senha != ctx.user.hash_senha
      assert Repo.aggregate(Token, :count) == 0
    end
  end
end
