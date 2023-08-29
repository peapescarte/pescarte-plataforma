defmodule Pescarte.Catalogo.Models.PeixeTest do
  use Database.DataCase, async: true

  alias Catalogo.Models.Peixe

  @moduletag :unit

  test "alterações válidas no changeset" do
    attrs = %{
      nome_cientifico: "nome cientifico",
      nativo?: true,
      link_imagem: "https://link.com"
    }

    changeset = Peixe.changeset(%Peixe{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome_cientifico) == "nome cientifico"
    assert get_change(changeset, :nativo?)
    assert get_change(changeset, :link_imagem) == "https://link.com"

  end
end
