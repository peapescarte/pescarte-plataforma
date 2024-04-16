defmodule Identidades.Handlers.UsuarioHandlerTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Identidades.Handlers.UsuarioHandler
  alias Pescarte.Identidades.Models.Usuario

  @moduletag :unit

  describe "create_usuario" do
    test "quando os atributos são inválidos" do
      assert {:error, %Ecto.Changeset{}} = UsuarioHandler.create_usuario_admin(%{})
      assert {:error, %Ecto.Changeset{}} = UsuarioHandler.create_usuario_pesquisador(%{})
    end

    test "quando os atributos são válidos" do
      assert {:ok, %Usuario{}} =
               :usuario_creation
               |> build()
               |> UsuarioHandler.create_usuario_admin()

      assert {:ok, %Usuario{}} =
               :usuario_creation
               |> build()
               |> UsuarioHandler.create_usuario_pesquisador()
    end
  end

  describe "fetch_usuario_by_cpf_and_password/2" do
    test "quando o cpf ou a senha sãos inválidos" do
      user = insert(:usuario)

      assert {:error, :not_found} =
               UsuarioHandler.fetch_usuario_by_cpf_and_password("123", user.senha)

      assert {:error, :invalid_password} =
               UsuarioHandler.fetch_usuario_by_cpf_and_password(user.cpf, "123")
    end

    test "quando o cpf e a senha são válidos" do
      user = insert(:usuario)

      assert {:ok, fetched} =
               UsuarioHandler.fetch_usuario_by_cpf_and_password(user.cpf, user.senha)

      assert fetched.id == user.id
      assert fetched.cpf == user.cpf
    end
  end

  describe "fetch_usuario_by_email_and_password/2" do
    test "quando o email ou a senha sãos inválidos" do
      # user = insert(:usuario)
      user = Repo.preload(insert(:usuario), :contato)

      assert {:error, :not_found} =
               UsuarioHandler.fetch_usuario_by_email_and_password("123", user.senha)

      assert {:error, :invalid_password} =
               UsuarioHandler.fetch_usuario_by_email_and_password(
                 user.contato.email_principal,
                 "123"
               )
    end

    test "quando o email e a senha são válidos" do
      # user = insert(:usuario)
      user = Repo.preload(insert(:usuario), :contato)

      assert {:ok, fetched} =
               UsuarioHandler.fetch_usuario_by_email_and_password(
                 user.contato.email_principal,
                 user.senha
               )

      assert fetched.id == user.id
      assert fetched.cpf == user.cpf
    end
  end
end
