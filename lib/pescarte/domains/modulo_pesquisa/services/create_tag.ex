defmodule Pescarte.Domains.ModuloPesquisa.Services.CreateTag do
  use Pescarte, :application_service

  alias Pescarte.Domains.ModuloPesquisa.IO.TagRepo

  @impl true
  def process(params) do
    TagRepo.insert(params)
  end
end
