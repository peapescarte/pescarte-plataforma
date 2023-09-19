defmodule ModuloPesquisa.Handlers.IManageRelatoriosHandler do
  alias ModuloPesquisa.Schemas.RelatorioPesquisa

  @opaque changeset :: Ecto.Changeset.t()

  @callback change_relatorio_pesquisa(RelatorioPesquisa.t(), map) :: changeset
  @callback change_relatorio_mensal(RelatorioPesquisa.t(), map) :: changeset
  @callback list_relatorios(sorter) :: list(RelatorioPesquisa.t())
            when sorter: function
  @callback list_relatorios_from_pesquisador(id, sorter) :: list(RelatorioPesquisa.t())
            when sorter: function,
                 id: String.t()
end
