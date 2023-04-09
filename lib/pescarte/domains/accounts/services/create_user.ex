defmodule Pescarte.Domains.Accounts.Services.CreateUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.Models.User

  @impl true
  def process(params) do
    with {:ok, changeset} <- User.pesquisador_changeset(params) do
      Database.insert(changeset)
    end
  end

  def process(params, :admin) do
    with {:ok, changeset} <- User.admin_changeset(params) do
      Database.insert(changeset)
    end
  end
end
