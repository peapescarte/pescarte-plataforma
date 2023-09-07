defmodule Pescarte.Catalogo.Models.HabitatTest do
  use Database.DataCase, async: true

  alias Catalogo.Models.Habitat

  @moduletag :unit

  test "alterações válidas no changeset" do
    attrs = %{
      nome: "nome do habitat"
    }

    changeset = Habitat.changeset(%Habitat{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome) == "nome do habitat"
  end
end
