defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateCategoria do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  @impl true
  def process(params) do
    with {:ok, changeset} <- Categoria.changeset(params) do
      Database.insert(changeset)
    end
  end
end
