defmodule Pescarte.Database.Supervisor do
  use Supervisor

  alias Pescarte.Database.{Repo, Repo.Replica}

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Supervisor.init(children(), strategy: :one_for_all)
  end

  defp children do
    if Pescarte.env() != :test do
      [Repo, Replica]
    else
      [Repo]
    end
  end
end
