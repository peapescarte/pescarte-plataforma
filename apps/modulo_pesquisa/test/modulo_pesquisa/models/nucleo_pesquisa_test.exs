defmodule Pescarte.ModuloPesquisa.Models.NucleoPesquisaTest do
  use Database.DataCase, async: true

  alias ModuloPesquisa.Models.NucleoPesquisa

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: "Descrição do Núcleo"
    }

    changeset = NucleoPesquisa.changeset(%NucleoPesquisa{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "Nome do Núcleo"
    assert get_change(changeset, :letra) == "A"
    assert get_change(changeset, :desc) == "Descrição do Núcleo"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A"
    }

    changeset = NucleoPesquisa.changeset(%NucleoPesquisa{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end

  test "alterações inválidas no changeset com desc muito longa" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: String.duplicate("a", 401)
    }

    changeset = NucleoPesquisa.changeset(%NucleoPesquisa{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end
end
