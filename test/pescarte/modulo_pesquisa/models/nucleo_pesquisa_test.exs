defmodule Pescarte.ModuloPesquisa.Models.NucleoPesquisaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: "Descrição do Núcleo"
    }

    changeset = NucleoPesquisa.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "Nome Do Núcleo"
    assert get_change(changeset, :letra) == "A"
    assert get_change(changeset, :desc) == "Descrição do Núcleo"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A"
    }

    changeset = NucleoPesquisa.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end

  test "alterações inválidas no changeset com desc muito longa" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: "a" |> String.duplicate(401)
    }

    changeset = NucleoPesquisa.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end

  test "alterações válidas no changeset de atualização" do
    nucleo_pesquisa = insert(:nucleo_pesquisa)
    attrs = %{desc: "Nova descrição"}

    changeset = NucleoPesquisa.update_changeset(nucleo_pesquisa, attrs)

    assert changeset.valid?
    assert get_change(changeset, :desc) == "Nova descrição"
  end
end
