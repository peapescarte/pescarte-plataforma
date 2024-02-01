defmodule Pescarte.Database.Repo do
  @moduledoc """
  Repositorio especifico para escrita do banco de dados
  """
  use Ecto.Repo, otp_app: :pescarte, adapter: Ecto.Adapters.Postgres

  def replica, do: Pescarte.Database.Repo.Replica

  def default_dynamic_repo do
    if Pescarte.env() != :test do
      Pescarte.Database.Repo.Replica
    else
      Pescarte.Database.Repo
    end
  end
end

defmodule Pescarte.Database.Repo.Replica do
  use Ecto.Repo,
    otp_app: :pescarte,
    adapter: Ecto.Adapters.Postgres,
    read_only: true,
    default_dynamic_repo: Pescarte.Database.Repo.default_dynamic_repo()
end
