defmodule Pescarte.ModuloPesquisa.Models.RelatorioPesquisaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.ModuloPesquisa.Factory

  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      data_inicio: ~D[2021-01-01],
      data_fim: ~D[2021-12-31],
      data_limite: ~D[2022-01-01],
      status: :pendente,
      tipo: Enum.random(~w(mensal trimestral anual)),
      pesquisador_id: insert(:pesquisador).id_publico
    }

    changeset = RelatorioPesquisa.changeset(%RelatorioPesquisa{}, attrs)

    assert changeset.valid?
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    changeset = RelatorioPesquisa.changeset(%RelatorioPesquisa{}, %{})

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :status)
    assert Keyword.get(changeset.errors, :tipo)
    assert Keyword.get(changeset.errors, :pesquisador_id)
  end
end
