defmodule Pescarte.ModuloPesquisa.Models.RelatorioMensalTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    pesquisador = insert(:pesquisador)

    attrs = %{
      ano: 2023,
      mes: 1,
      pesquisador_id: pesquisador.id,
      acao_planejamento: "Ação de Planejamento",
      participacao_grupos_estudo: "Participação em Grupos de Estudo",
      acoes_pesquisa: "Ações de Pesquisa",
      participacao_treinamentos: "Participação em Treinamentos",
      publicacao: "Publicação"
    }

    changeset = RelatorioMensal.changeset(attrs)

    assert changeset.valid?
    assert get_change(changeset, :ano) == 2023
    assert get_change(changeset, :mes) == 1
    assert get_change(changeset, :acao_planejamento) == "Ação de Planejamento"

    assert get_change(changeset, :participacao_grupos_estudo) ==
             "Participação em Grupos de Estudo"

    assert get_change(changeset, :acoes_pesquisa) == "Ações de Pesquisa"
    assert get_change(changeset, :participacao_treinamentos) == "Participação em Treinamentos"
    assert get_change(changeset, :publicacao) == "Publicação"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    pesquisador = insert(:pesquisador)

    attrs = %{
      mes: 1,
      pesquisador_id: pesquisador.id,
      acao_planejamento: "Ação de Planejamento",
      participacao_grupos_estudo: "Participação em Grupos de Estudo",
      acoes_pesquisa: "Ações de Pesquisa",
      participacao_treinamentos: "Participação em Treinamentos"
    }

    changeset = RelatorioMensal.changeset(attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :ano)
  end
end
