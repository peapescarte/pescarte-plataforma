defmodule Fuschia.Context.NucleosTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Nucleos
  alias Fuschia.Entities.Nucleo

  describe "list/0" do
    test "return all nucleos in database" do
      nucleo =
        :nucleo
        |> insert()
        |> Nucleos.preload_all()

      assert [nucleo] == Nucleos.list()
    end
  end

  describe "one/1" do
    test "when nome is valid, returns a nucleo" do
      nucleo =
        :nucleo
        |> insert()
        |> Nucleos.preload_all()

      assert nucleo == Nucleos.one(nucleo.nome)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Nucleos.one(""))
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      nome: nil,
      descricao: nil
    }

    test "when all params are valid, creates an admin nucleo" do
      attrs = params_for(:nucleo)
      assert {:ok, %Nucleo{}} = Nucleos.create(attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Nucleos.create(@invalid_attrs)
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
      assert {:ok, nucleo} = Nucleos.create(attrs)

      assert {:ok, updated_nucleo} = Nucleos.update(nucleo.nome, @update_attrs)

      assert updated_nucleo.nome == @update_attrs.nome
      assert updated_nucleo.descricao == @update_attrs.descricao
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:nucleo)
      assert {:ok, nucleo} = Nucleos.create(attrs)

      assert {:error, %Ecto.Changeset{}} = Nucleos.update(nucleo.nome, @invalid_attrs)
    end
  end
end
