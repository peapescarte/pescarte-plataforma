defmodule Pescarte.ModuloPesquisa.Handlers.PesquisadorHandler do
  alias Pescarte.ModuloPesquisa.Adapters.PesquisadorAdapter
  alias Pescarte.ModuloPesquisa.Handlers.IManagePesquisadorHandler
  alias Pescarte.ModuloPesquisa.Repository

  @behaviour IManagePesquisadorHandler

  @impl true
  def list_pesquisadores do
    Repository.list_pesquisador()
    |> Enum.sort_by(& &1.usuario.primeiro_nome)
    |> Enum.map(&PesquisadorAdapter.internal_to_external/1)
  end
end
