defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo

  @impl true
  def process(params) do
    with {:ok, midia} <- MidiaRepo.fetch(params.midia_id) do
      MidiaRepo.update(midia, params)
    end
  end
end
