defmodule Database.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Listagem de repositorios do Pescarte
    children = [
      Database.EscritaRepo,
      Database.LeituraRepo
    ]

    opts = [strategy: :one_for_one, name: Database.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
