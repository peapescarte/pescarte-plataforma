defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.TagRepo
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @impl true
  def process(%Tag{} = tag) do
    tag
    |> Map.from_struct()
    |> Map.put(:tag_id, tag.id)
    |> process()
  end

  def process(%{} = params) do
    with {:ok, tag} <- TagRepo.fetch(params[:tag_id]) do
      TagRepo.update(tag, params)
    end
  end
end
