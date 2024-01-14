defmodule Identidades.Models.UsuarioTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Identidades.Models.Usuario

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    contato = insert(:contato)

    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "82879666040",
      data_nascimento: ~D[1990-01-01],
      contato_email: contato.email_principal,
      tipo: :pesquisador
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    assert get_change(changeset, :primeiro_nome) == "John"
    assert get_change(changeset, :sobrenome) == "Doe"
    assert get_change(changeset, :cpf) == "82879666040"
    assert get_change(changeset, :data_nascimento) == ~D[1990-01-01]
  end

  test "changeset inválido sem campos obrigatórios" do
    attrs = %{}

    changeset = Usuario.changeset(%Usuario{}, attrs)

    refute changeset.valid?
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
      tipo: :pesquisador,
      contato_email: contato.email_principal
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cpf)
  end

  test "changeset inválido sem contato associado" do
    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      tipo: :pesquisador,
      contato_email: nil
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :contato_email)
  end

  test "changeset inválido com senha nula e tipo pesquisador" do
    user = insert(:usuario)

    attrs = %{
      senha: nil,
      senha_confirmation: nil
    }

    changeset = Usuario.password_changeset(user, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha)
  end

  test "changeset inválido com senhas não coincidentes" do
    user = insert(:usuario)

    attrs = %{
      senha: "Password123!",
      senha_confirmation: "DifferentPassword456?"
    }

    changeset = Usuario.password_changeset(user, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :senha_confirmation)
  end

  test "changeset inválido com senha fraca" do
    user = insert(:usuario)

    attrs = %{
      senha: "weakpassword",
      senha_confirmation: "weakpassword"
    }

    changeset = Usuario.password_changeset(user, attrs)

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
      contato_email: contato.email_principal,
      tipo: :admin
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :tipo) == :admin
  end

  test "changeset válido com confirmado_em" do
    user = insert(:usuario)

    changeset = Usuario.confirm_changeset(user, ~U[2023-05-01T12:00:00Z])

    assert changeset.valid?
    assert get_change(changeset, :confirmado_em) == ~U[2023-05-01T12:00:00Z]
  end
end
