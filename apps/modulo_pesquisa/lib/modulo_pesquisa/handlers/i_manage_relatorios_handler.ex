defmodule ModuloPesquisa.Handlers.IManageRelatoriosHandler do
  alias ModuloPesquisa.Schemas.RelatorioPesquisa

  @callback list_relatorios(sorter) :: list(RelatorioPesquisa.t())
            when sorter: function
  @callback list_relatorios_from_pesquisador(id, sorter) :: list(RelatorioPesquisa.t())
            when sorter: function,
                 id: String.t()
end
