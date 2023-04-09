defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @impl true
  def process(%Tag{} = tag) do
    tag
    |> Map.from_struct()
    |> Map.put(:tag_id, tag.id)
    |> process()
  end

  def process(%{} = params) do
    with tag = %Tag{} <- Database.get(Tag, params[:tag_id]),
         {:ok, changeset} <- Tag.changeset(tag, params) do
      Database.update(changeset)
    end
  end
end
