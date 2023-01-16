defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo

  @impl true
  def process(params) do
    MidiaRepo.insert(params)
  end
end
