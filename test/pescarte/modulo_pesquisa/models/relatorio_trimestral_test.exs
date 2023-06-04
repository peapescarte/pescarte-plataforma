defmodule Pescarte.ModuloPesquisa.Models.RelatorioTrimestralTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      ano: 2023,
      mes: 1,
      pesquisador_id: insert(:pesquisador).id,
      status: :entregue
    }

    assert {:ok, relatorio_trimestral} = RelatorioTrimestral.changeset(attrs)
    assert relatorio_trimestral.ano == 2023
    assert relatorio_trimestral.mes == 1
    assert relatorio_trimestral.status == :entregue
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    assert {:error, changeset} = RelatorioTrimestral.changeset(%{})
    assert Keyword.get(changeset.errors, :ano)
    assert Keyword.get(changeset.errors, :mes)
    assert Keyword.get(changeset.errors, :pesquisador_id)
  end
end
