defmodule Pescarte.Accounts.AccountsTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.Accounts

  import Pescarte.Factory

  @moduletag :unit

  @now NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  describe "confirm_user/1" do
    test "quando o token de confirmação é inválido" do
      assert {:error, :invalid_token} = Accounts.confirm_user("um token", @now)
    end

    test "quando o token de confirmação não existe para um usuário" do
      token = :crypto.strong_rand_bytes(32)
      insert(:user_token, token: :crypto.hash(:sha256, token))
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

      insert(:user_token, params)
      confirm_token = Base.url_encode64(token)

      assert {:ok, confirmed} = Accounts.confirm_user(confirm_token, @now)
      assert confirmed.id == user.id
      assert confirmed.confirmado_em == @now
    end
  end
end
