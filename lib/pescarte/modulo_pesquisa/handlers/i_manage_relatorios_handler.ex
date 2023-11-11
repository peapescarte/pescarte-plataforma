defmodule Pescarte.ModuloPesquisa.Handlers.IManageRelatoriosHandler do
  alias Pescarte.ModuloPesquisa.Schemas.RelatorioPesquisa

  @callback change_relatorio_pesquisa(relatorio, attrs) :: Ecto.Changeset.t()
            when relatorio: RelatorioPesquisa.t(),
                 attrs: map
  @callback list_relatorios(sorter) :: list(RelatorioPesquisa.t())
            when sorter: function
  @callback list_relatorios_from_pesquisador(id, sorter) :: list(RelatorioPesquisa.t())
            when sorter: function,
                 id: String.t()
end
