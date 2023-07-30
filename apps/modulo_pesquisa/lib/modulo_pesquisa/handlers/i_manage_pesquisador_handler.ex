defmodule ModuloPesquisa.Handlers.IManagePesquisadorHandler do
  alias ModuloPesquisa.Models.Pesquisador

  @callback list_pesquisadores() :: [Pesquisador.t()]
  @callback struct_to_wire_out_listagem(Pesquisador.t()) :: map()
end
