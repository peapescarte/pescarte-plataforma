defmodule Pescarte.Domains.Accounts.Services.CreateUser do
  use Pescarte, :application_service

  alias Pescarte.Domains.Accounts.Models.User

  @doc """
  O usuário padrão da plataforma são os pesquisadores
  """
  @impl true
  def process(params) do
    process(params, :pesquisador)
  end

  @impl true
  def process(params, :pesquisador) do
    params
    |> User.pesquisador_changeset()
    |> Repo.insert()
  end

  def process(params, :admin) do
    params
    |> User.admin_changeset()
    |> Repo.insert()
  end
end
