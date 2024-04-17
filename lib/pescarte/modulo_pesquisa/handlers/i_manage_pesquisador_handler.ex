defmodule Pescarte.ModuloPesquisa.Handlers.IManagePesquisadorHandler do
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @callback list_pesquisadores(params :: map) :: [Pesquisador.t()]
end
