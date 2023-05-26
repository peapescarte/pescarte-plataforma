defmodule Pescarte.Accounts.Services.CreateUserTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Repo
  alias Pescarte.Domains.Accounts.Services.CreateUser

  test "create pesquisador user" do
    params = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "074.791.860-02",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "Password123!",
      senha_confirmation: "Password123!"
    }

    {:ok, user} = CreateUser.process(params)

    assert user.id
    assert user.tipo == :pesquisador
    assert user.contato.id
    assert user.senha == nil
    assert user.confirmado_em == nil
  end

  test "create admin user" do
    params = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "074.791.860-02",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "Password123!",
      senha_confirmation: "Password123!"
    }

    {:ok, user} = CreateUser.process(params, :admin)

    assert user.id
    assert user.tipo == :admin
    assert user.contato.id
    assert user.senha == nil
    assert user.confirmado_em == nil
  end

  test "create pesquisador user with invalid params" do
    params = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "074.791.860-02",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "weakpassword",
      senha_confirmation: "weakpassword"
    }

    assert {:error, _changeset} = CreateUser.process(params)
  end
end
