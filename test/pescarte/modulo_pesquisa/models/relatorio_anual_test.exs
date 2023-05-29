defmodule Pescarte.ModuloPesquisa.Models.RelatorioAnualTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      ano: 2023,
      mes: 1,
      pesquisador_id: insert(:pesquisador).id
    }

    changeset = RelatorioAnual.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :ano) == 2023
    assert get_change(changeset, :mes) == 1
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    changeset = RelatorioAnual.changeset(%{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :ano)
    assert Keyword.get(changeset.errors, :mes)
    assert Keyword.get(changeset.errors, :pesquisador_id)
  end
end
