defmodule Pescarte.Domains.ModuloPesquisa.Services.GetCategoria do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def process do
    Database.all(Categoria)
  end

  @impl true
  def process(id: id) do
    Database.get(Categoria, id)
  end

  def process(params) do
    Database.get_by(Categoria, params)
  end
end
