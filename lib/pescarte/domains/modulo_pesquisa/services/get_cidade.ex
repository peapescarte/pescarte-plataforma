defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCidade do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade

  @impl true
  def process(id: id) do
    Database.get(Cidade, id)
  end

  def process(params) do
    Database.get_by(Cidade, params)
  end
end
