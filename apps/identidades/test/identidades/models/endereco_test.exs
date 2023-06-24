defmodule Identidades.Models.EnderecoTest do
  use Database.DataCase, async: true

  alias Identidades.Models.Endereco

  @moduletag :unit

  test "cria um endereco sem cep obrigatório" do
    attrs = %{}

    changeset = Endereco.changeset(%Endereco{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :cep)
  end

  test "cria um endereço com todos os campos" do
    attrs = %{
      cep: "28030-001",
      cidade: "Campos dos Goytacazes",
      estado: "rio de janeiro",
      numero: "123",
      rua: "Teste",
      complemento: "um complemento"
    }

    changeset = Endereco.changeset(%Endereco{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :estado) == "rio de janeiro"
  end
end
