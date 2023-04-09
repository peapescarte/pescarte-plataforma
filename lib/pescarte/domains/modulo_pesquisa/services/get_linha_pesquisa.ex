defmodule Pescarte.Domains.ModuloPesquisa.Services.GetLinhaPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  def process do
    Database.all(LinhaPesquisa)
  end

  @impl true
  def process(id: id) do
    Database.get(LinhaPesquisa, id)
  end
end
