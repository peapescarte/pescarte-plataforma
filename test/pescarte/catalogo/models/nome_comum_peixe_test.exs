defmodule Pescarte.Catalogo.Models.NomeComumPeixeTest do
  use Pescarte.DataCase, async: true

  alias Pescarte.Catalogo.Models.NomeComumPeixe

  @moduletag :unit

  test "alterações válidas no changeset" do
    attrs = %{
      nome_comum: "Sardinha",
      nome_cientifico: "Sardinella brasiliensis",
      comunidade_nome: "Comunidade A",
      validado?: true
    }

    changeset = NomeComumPeixe.changeset(%NomeComumPeixe{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome_comum) == "Sardinha"
    assert get_change(changeset, :nome_cientifico) == "Sardinella brasiliensis"
    assert get_change(changeset, :comunidade_nome) == "Comunidade A"
    assert get_change(changeset, :validado?)
  end
    assert get_change(changeset, :nativo?)
    assert get_change(changeset, :link_imagem) == "https://link.com"
  end
end
