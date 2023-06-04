defmodule Pescarte.ModuloPesquisa.Models.NucleoPesquisaTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: "Descrição do Núcleo"
    }

    assert {:ok, nucleo} = NucleoPesquisa.changeset(attrs)
    assert nucleo.nome == "Nome do Núcleo"
    assert nucleo.letra == "A"
    assert nucleo.desc == "Descrição do Núcleo"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A"
    }

    assert {:error, changeset} = NucleoPesquisa.changeset(attrs)
    assert Keyword.get(changeset.errors, :desc)
  end

  test "alterações inválidas no changeset com desc muito longa" do
    attrs = %{
      nome: "Nome do Núcleo",
      letra: "A",
      desc: String.duplicate("a", 401)
    }

    assert {:error, changeset} = NucleoPesquisa.changeset(attrs)
    assert Keyword.get(changeset.errors, :desc)
  end
end
