defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.MidiaRepo
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  @impl true
  def process(%Midia{} = midia) do
    midia
    |> Map.from_struct()
    |> Map.put(:midia_id, midia.id)
    |> process()
  end

  def process(%{} = params) do
    with {:ok, midia} <- MidiaRepo.fetch(params[:midia_id]) do
      MidiaRepo.update(midia, params)
    end
  end
end
