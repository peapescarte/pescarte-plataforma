defmodule Pescarte.Accounts.Models.UsuarioTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.Accounts.Models.User

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato)
    }

    changeset = User.changeset(attrs)

    assert changeset.valid?
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    changeset = User.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cpf)
    assert Keyword.get(changeset.errors, :primeiro_nome)
    assert Keyword.get(changeset.errors, :sobrenome)
    assert Keyword.get(changeset.errors, :data_nascimento)
  end

  test "changeset com CPF inválido" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "12345678900",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato)
    }

    changeset = User.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cpf)
  end

  test "changeset inválido sem contato associado" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: nil
    }

    changeset = User.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :contato)
  end

  test "changeset válido com tipo pesquisador" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "Password123!",
      senha_confirmation: "Password123!"
    }

    changeset = User.pesquisador_changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :tipo) == :pesquisador
  end

  test "changeset inválido com senha nula e tipo pesquisador" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: nil,
      senha_confirmation: nil
    }

    changeset = User.pesquisador_changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha)
  end

  test "changeset inválido com senhas não coincidentes e tipo pesquisador" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "Password123!",
      senha_confirmation: "DifferentPassword456?"
    }

    changeset = User.pesquisador_changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha_confirmation)
  end

  test "changeset inválido com senha fraca e tipo pesquisador" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "weakpassword",
      senha_confirmation: "weakpassword"
    }

    changeset = User.pesquisador_changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha)
  end

  test "changeset válido com tipo admin" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato: attrs(:contato),
      senha: "Password123!",
      senha_confirmation: "Password123!"
    }

    changeset = User.admin_changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :tipo) == :admin
  end

  test "changeset válido com confirmado_em" do
    user = insert(:user)
    changeset = User.confirm_changeset(user, ~U[2023-05-01T12:00:00Z])

    assert changeset.valid?
    assert get_change(changeset, :confirmado_em) == ~U[2023-05-01T12:00:00Z]
  end

  test "changeset válido com mudança de email e usuário já existente" do
    user = insert(:user)
    attrs = %{email_principal: "new-email@example.com"}

    changeset = User.email_changeset(user, attrs)

    assert changeset.valid?
    assert get_change(changeset, :email_principal) == "new-email@example.com"
  end
end
