defmodule Fuschia.Queries.NucleosTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Database
  alias Fuschia.Entities.Nucleo
  alias Fuschia.Queries.Nucleos

  @moduletag :unit

  describe "list/0" do
    test "return all nucleos in database" do
      insert(:nucleo)

      nucleo = Database.one(Nucleos.query())

      assert [nucleo] == Database.list(Nucleos.query())
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a nucleo" do
      insert(:nucleo)

      nucleo = Database.one(Nucleos.query())

      assert nucleo == Database.get(Nucleos.query(), nucleo.nome)
    end

    test "when id is invalid, returns nil" do
      assert Nucleos.query() |> Database.get("") |> is_nil()
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      nome: nil,
      descricao: nil
    }

    test "when all params are valid, creates an admin nucleo" do
      valid_attrs = params_for(:nucleo)

      assert {:ok, %Nucleo{}} = Database.create(Nucleo, valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Database.create(Nucleo, @invalid_attrs)
    end
  end

  describe "update/1" do
    @update_attrs %{
      nome: "Nucleo Teste",
      descricao: "Nucleo Descricao Teste"
    }

    @invalid_attrs %{
      nome: nil,
      descricao: nil
    }

    test "when all params are valid, updates a nucleo" do
      attrs = params_for(:nucleo)

      assert {:ok, nucleo} = Database.create(Nucleo, attrs)

      assert {:ok, updated_nucleo} =
               Database.update(Nucleos.query(), &Nucleo.changeset/2, nucleo.nome, @update_attrs)

      assert updated_nucleo.nome == @update_attrs.nome
      assert updated_nucleo.descricao == @update_attrs.descricao
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:nucleo)

      assert {:ok, nucleo} = Database.create(Nucleo, attrs)

      assert {:error, %Ecto.Changeset{}} =
               Database.update(Nucleos.query(), &Nucleo.changeset/2, nucleo.nome, @invalid_attrs)
    end
  end
end
