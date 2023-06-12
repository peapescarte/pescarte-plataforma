defmodule Pescarte.Accounts.Models.ContatoTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.Accounts.Models.Contato

  @moduletag :unit

  test "changeset com emails e celulares adicionais" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "22123456789",
      emails_adicionais: ["test2@example.com", "test3@example.com"],
      celulares_adicionais: ["22987654321", "22987654322"],
      endereco_id: endereco.id
    }

    assert {:ok, contato} = Contato.changeset(attrs)
    assert contato.email_principal == "test@example.com"
    assert contato.celular_principal == "22123456789"
    assert contato.emails_adicionais == ["test2@example.com", "test3@example.com"]
    assert contato.celulares_adicionais == ["22987654321", "22987654322"]
    assert contato.endereco_id == endereco.id
  end

  test "changeset com emails e celulares adicionais vazios" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "22123456789",
      emails_adicionais: [],
      celulares_adicionais: [],
      endereco_id: endereco.id
    }

    assert {:ok, contato} = Contato.changeset(attrs)
    assert contato.email_principal == "test@example.com"
    assert contato.celular_principal == "22123456789"
    assert contato.emails_adicionais == []
    assert contato.celulares_adicionais == []
    assert contato.endereco_id == endereco.id
  end

  test "changeset com emails e celulares adicionais duplicados" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "22123456789",
      emails_adicionais: ["test2@example.com", "test2@example.com"],
      celulares_adicionais: ["22987654321", "22987654321"],
      endereco_id: endereco.id
    }

    assert {:error, changeset} = Contato.changeset(attrs)
    assert Keyword.get(changeset.errors, :emails_adicionais)
    assert Keyword.get(changeset.errors, :celulares_adicionais)
  end

  test "changeset sem campos adicionais" do
    endereco = insert(:endereco)

    attrs = %{
      email_principal: "test@example.com",
      celular_principal: "22123456789",
      endereco_id: endereco.id
    }

    assert {:ok, contato} = Contato.changeset(attrs)
    assert contato.email_principal == "test@example.com"
    assert contato.celular_principal == "22123456789"
    assert contato.endereco_id == endereco.id
  end
end
