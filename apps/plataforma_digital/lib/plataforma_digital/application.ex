defmodule PlataformaDigital.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PlataformaDigital.Telemetry,
      # Start the Endpoint (http/https)
      PlataformaDigital.Endpoint,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pescarte.PubSub}
    ]

    opts = [strategy: :one_for_one, name: PlataformaDigital.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(keyword, keyword, keyword) :: :ok
  def config_change(changed, _new, removed) do
    PlataformaDigital.Endpoint.config_change(changed, removed)
    :ok
  end
end
