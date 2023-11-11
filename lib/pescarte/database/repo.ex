defmodule Pescarte.Database.Repo do
  @moduledoc """
  Repositorio especifico para escrita do banco de dados
  """
  use Ecto.Repo, otp_app: :pescarte, adapter: Ecto.Adapters.Postgres

  alias Pescarte.Database.Repo

  def replica, do: Repo.Replica

  def default_dynamic_repo do
    if Pescarte.config_env() != :test do
      Repo.Replica
    else
      Repo
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
