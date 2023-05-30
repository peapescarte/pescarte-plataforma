defmodule Pescarte.Accounts.Models.UsuarioTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.Accounts.Models.User

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    contato = insert(:contato)

    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "82879666040",
      data_nascimento: ~D[1990-01-01],
      contato_id: contato.id
    }

    assert {:ok, user} = User.changeset(attrs)
    assert user.primeiro_nome == "John"
    assert user.sobrenome == "Doe"
    assert user.cpf == "82879666040"
    assert user.data_nascimento == ~D[1990-01-01]
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    assert {:error, changeset} = User.changeset(attrs)
    assert Keyword.get(changeset.errors, :cpf)
    assert Keyword.get(changeset.errors, :primeiro_nome)
    assert Keyword.get(changeset.errors, :sobrenome)
    assert Keyword.get(changeset.errors, :data_nascimento)
  end

  test "changeset com CPF inválido" do
    contato = insert(:contato)

    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "12345678900",
      data_nascimento: ~D[1990-01-01],
      contato_id: contato.id
    }

    assert {:error, changeset} = User.changeset(attrs)
    assert Keyword.get(changeset.errors, :cpf)
  end

  test "changeset inválido sem contato associado" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato_id: nil
    }

    assert {:error, changeset} = User.changeset(attrs)
    assert Keyword.get(changeset.errors, :contato_id)
  end

  test "changeset inválido com senha nula e tipo pesquisador" do
    user = insert(:user)

    attrs = %{
      senha: nil,
      senha_confirmation: nil
    }

    changeset = User.password_changeset(user, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha)
  end

  test "changeset inválido com senhas não coincidentes" do
    user = insert(:user)

    attrs = %{
      senha: "Password123!",
      senha_confirmation: "DifferentPassword456?"
    }

    changeset = User.password_changeset(user, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha_confirmation)
  end

  test "changeset inválido com senha fraca" do
    user = insert(:user)

    attrs = %{
      senha: "weakpassword",
      senha_confirmation: "weakpassword"
    }

    changeset = User.password_changeset(user, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha)
  end

  test "changeset válido com tipo admin" do
    contato = insert(:contato)

    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato_id: contato.id,
      tipo: :admin
    }

    assert {:ok, user} = User.changeset(attrs)
    assert user.tipo == :admin
  end

  test "changeset válido com confirmado_em" do
    user = insert(:user)

    changeset = User.confirm_changeset(user, ~U[2023-05-01T12:00:00Z])

    assert changeset.valid?
    assert get_change(changeset, :confirmado_em) == ~U[2023-05-01T12:00:00Z]
  end
end
