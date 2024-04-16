defmodule Pescarte.ModuloPesquisa.Handlers.PesquisadorHandler do
  alias Pescarte.ModuloPesquisa.Adapters.PesquisadorAdapter
  alias Pescarte.ModuloPesquisa.Handlers.IManagePesquisadorHandler
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Repository

  @behaviour IManagePesquisadorHandler

  @impl true
  def list_pesquisadores(params \\ %{}) do
    with {:ok, flop} <- Flop.validate(params, for: Pesquisador),
         {data, meta} <- Repository.list_pesquisador(flop) do
      data = Enum.map(data, &PesquisadorAdapter.internal_to_external/1)
      {:ok, {data, meta}}
    end
  end

  def list_relatorios_pesquisa(params \\ %{}) do
    with {:ok, flop} <- Flop.validate(params, for: Pesquisador),
         {data, meta} <- Repository.list_relatorios_pesquisa(flop) do
      {:ok, {data, meta}}
    end
  end
end
