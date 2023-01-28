defmodule Pescarte.Domains.ModuloPesquisa.Services.GetTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.TagRepo
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def process do
    TagRepo.all()
  end

  @impl true
  def process(%Midia{} = midia) do
    TagRepo.all_by_midia(midia)
  end

  def process(%Categoria{} = categoria) do
    TagRepo.all_by_categoria(categoria)
  end

  def process(params) do
    TagRepo.fetch_by(params)
  end
end
