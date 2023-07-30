defmodule ModuloPesquisa.Handlers.IManagePesquisadorHandler do
  alias ModuloPesquisa.Models.Pesquisador

  @callback list_pesquisadores() :: [Pesquisador.t()]
end
