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

    assert {:ok, relatorio_mensal} = RelatorioMensal.changeset(attrs)
    assert relatorio_mensal.ano == 2023
    assert relatorio_mensal.mes == 1
    assert relatorio_mensal.acao_planejamento == "Ação de Planejamento"

    assert relatorio_mensal.participacao_grupos_estudo ==
             "Participação em Grupos de Estudo"

    assert relatorio_mensal.acoes_pesquisa == "Ações de Pesquisa"
    assert relatorio_mensal.participacao_treinamentos == "Participação em Treinamentos"
    assert relatorio_mensal.publicacao == "Publicação"
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

    assert {:error, changeset} = RelatorioMensal.changeset(attrs)
    assert Keyword.get(changeset.errors, :ano)
  end
end
