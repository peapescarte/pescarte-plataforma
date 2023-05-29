defmodule Pescarte.Accounts.Models.ContatoTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.Accounts.Models.Contato

  @moduletag :unit

  test "changeset com emails e celulares adicionais" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "(22)12345-6789",
      emails_adicionais: ["test2@example.com", "test3@example.com"],
      celulares_adicionais: ["(22)98765-4321", "(22)98765-4322"],
      endereco_id: endereco.id
    }

    changeset = Contato.changeset(attrs)

    assert changeset.valid?
  end

  test "changeset com emails e celulares adicionais vazios" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "(22)12345-6789",
      emails_adicionais: [],
      celulares_adicionais: [],
      endereco_id: endereco.id
    }

    changeset = Contato.changeset(attrs)

    assert changeset.valid?
  end

  test "changeset com emails e celulares adicionais duplicados" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "(22)12345-6789",
      emails_adicionais: ["test2@example.com", "test2@example.com"],
      celulares_adicionais: ["(22)98765-4321", "(22)98765-4321"],
      endereco_id: endereco.id
    }

    changeset = Contato.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :emails_adicionais)
    assert Keyword.get(changeset.errors, :celulares_adicionais)
  end

  test "changeset sem campos adicionais" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "(22)12345-6789",
      endereco_id: endereco.id
    }

    changeset = Contato.changeset(attrs)

    assert changeset.valid?
  end

  test "changeset com formato de email e celular invalido" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example",
      celular_principal: "123456789",
      emails_adicionais: ["wrong@test@example"],
      celulares_adicionais: ["12345678910"],
      endereco_id: endereco.id
    }

    changeset = Contato.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :email_principal)
    assert Keyword.get(changeset.errors, :celular_principal)
    assert Keyword.get(changeset.errors, :emails_adicionais)
    assert Keyword.get(changeset.errors, :celulares_adicionais)
  end
end
