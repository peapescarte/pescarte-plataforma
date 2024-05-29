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
      contato_id: contato.id,
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
      contato_id: contato.id
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cpf)
  end

  test "changeset válido com tipo admin" do
    contato = insert(:contato)

    attrs = %{
      primeiro_nome: "John",
      sobrenome: "Doe",
      cpf: "828.796.660-40",
      data_nascimento: ~D[1990-01-01],
      contato_id: contato.id,
      papel: :admin
    }

    changeset = Usuario.changeset(%Usuario{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :papel) == :admin
  end
end
