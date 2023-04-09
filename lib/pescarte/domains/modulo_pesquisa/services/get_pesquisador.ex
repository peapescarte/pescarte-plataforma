defmodule Pescarte.Domains.ModuloPesquisa.Services.GetPesquisador do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  def process do
    Database.all(Pesquisador)
  end

  @impl true
  def process(id: id) do
    Database.get(Pesquisador, id)
  end

  def process(params) do
    Database.get_by(Pesquisador, params)
  end
end
