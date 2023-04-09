defmodule Pescarte.Domains.ModuloPesquisa.Services.UpdateMidia do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  @impl true
  def process(%Midia{} = midia) do
    midia
    |> Map.from_struct()
    |> Map.put(:midia_id, midia.id)
    |> process()
  end

  def process(%{} = params) do
    with midia = %Midia{} <- Database.get(Midia, params[:midia_id]),
         {:ok, changeset} <- Midia.update_changeset(midia, params) do
      Database.update(changeset)
    end
  end
end
