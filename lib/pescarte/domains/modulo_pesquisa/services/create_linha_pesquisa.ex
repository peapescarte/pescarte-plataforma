defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateLinhaPesquisa do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  @impl true
  def process(params) do
    params
    |> LinhaPesquisa.changeset()
    |> Repo.insert()
  end
end
