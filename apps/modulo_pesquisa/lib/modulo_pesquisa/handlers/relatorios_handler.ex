defmodule ModuloPesquisa.Handlers.RelatoriosHandler do
  alias ModuloPesquisa.Adapters.RelatorioAdapter
  alias ModuloPesquisa.Handlers.IManageRelatoriosHandler
  alias ModuloPesquisa.Models.RelatorioPesquisa
  alias ModuloPesquisa.Repository

  @behaviour IManageRelatoriosHandler

  @impl true
  def change_relatorio_pesquisa(%RelatorioPesquisa{} = relatorio, attrs \\ %{}) do
    RelatorioPesquisa.changeset(relatorio, attrs)
  end

  @impl true
  def list_relatorios_from_pesquisador(id, sorter \\ &sort_by_periodo/1) do
    id
    |> Repository.list_relatorios_pesquisa_from_pesquisador()
    |> Enum.sort_by(sorter)
    |> Enum.map(&RelatorioAdapter.internal_to_external/1)
  end

  @impl true
  def list_relatorios(sorter \\ &sort_by_periodo/1) do
    Repository.list_relatorios_pesquisa()
    |> Enum.sort_by(sorter)
    |> Enum.map(&RelatorioAdapter.internal_to_external/1)
  end

  defp sort_by_periodo(relatorio) do
    relatorio.mes + relatorio.ano
  end
end
