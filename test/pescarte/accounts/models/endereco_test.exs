defmodule Pescarte.Accounts.Models.EnderecoTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.Accounts.Models.Endereco

  test "cria um endereco sem cep obrigatório" do
    attrs = %{}

    changeset = Endereco.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cep)
  end

  test "cria um endereço com formato de cep errado" do
    attrs = %{cep: "12345678"}

    changeset = Endereco.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cep)
  end

  test "cria um endereço com todos os campos" do
    attrs = %{
      cep: "28030-001",
      cidade: "Campos dos Goytacazes",
      estado: "rio de janeiro",
      numero: 123,
      rua: "Teste",
      complemento: "um complemento",
    }

    changeset = Endereco.changeset(attrs)

    assert changeset.valid?
    assert changeset.changes.estado == "Rio De Janeiro"
  end
end
