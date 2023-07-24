defmodule PlataformaDigitalAPI.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Endpoint (http/https)
      PlataformaDigitalAPI.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PlataformaDigitalAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(keyword, keyword, keyword) :: :ok
  def config_change(changed, _new, removed) do
    PlataformaDigitalAPI.Endpoint.config_change(changed, removed)
    :ok
  end
end
