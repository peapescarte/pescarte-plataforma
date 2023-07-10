defmodule Database.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Listagem de repositorios do Pescarte
    repos =
      if Database.config_env() != :test do
        [
          Database.Repo,
          Database.Repo.Replica
        ]
      else
        [Database.Repo]
      end

    opts = [strategy: :one_for_one, name: Database.Supervisor]
    Supervisor.start_link(repos, opts)
  end
end
