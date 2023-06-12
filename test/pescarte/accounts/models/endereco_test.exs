defmodule Pescarte.Accounts.Models.EnderecoTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.Accounts.Models.Endereco

  @moduletag :unit

  test "cria um endereco sem cep obrigatório" do
    attrs = %{}

    assert {:error, changeset} = Endereco.changeset(attrs)
    assert Keyword.get(changeset.errors, :cep)
  end

  test "cria um endereço com todos os campos" do
    attrs = %{
      cep: "28030-001",
      cidade: "Campos dos Goytacazes",
      estado: "rio de janeiro",
      numero: 123,
      rua: "Teste",
      complemento: "um complemento"
    }

    assert {:ok, contato} = Endereco.changeset(attrs)
    assert contato.estado == "rio de janeiro"
  end
end
