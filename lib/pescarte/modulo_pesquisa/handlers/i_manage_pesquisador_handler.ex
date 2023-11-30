defmodule Pescarte.ModuloPesquisa.Handlers.IManagePesquisadorHandler do
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @callback list_pesquisadores() :: [Pesquisador.t()]
end
