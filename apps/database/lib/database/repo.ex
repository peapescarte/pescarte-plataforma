defmodule Database.Repo do
  @moduledoc """
  Repositorio especifico para escrita do banco de dados
  """
  use Ecto.Repo, otp_app: :database, adapter: Ecto.Adapters.Postgres

  def replica, do: Database.Repo.Replica

  def default_dynamic_repo do
    if Database.config_env() != :test do
      Database.Repo.Replica
    else
      Database.Repo
    end
  end
end

defmodule Database.Repo.Replica do
  use Ecto.Repo,
    otp_app: :database,
    adapter: Ecto.Adapters.Postgres,
    read_only: true,
    default_dynamic_repo: Database.Repo.default_dynamic_repo()
end
