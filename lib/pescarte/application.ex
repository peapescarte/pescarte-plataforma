defmodule Backend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, list) :: {:ok, pid} | {:error, any}
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Backend.Supervisor]

    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(keyword, keyword, keyword) :: :ok
  def config_change(changed, _new, removed) do
    BackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    base_children = [
      # Start the Ecto repository
      Backend.Repo,
      # Start the Telemetry supervisor
      BackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Backend.PubSub},
      # Start the Endpoint (http/https)
      BackendWeb.Endpoint,
      # Start external http client
      {Finch, name: HttpClientFinch, pools: %{default: [size: 10]}}
      # Start Oban jobs
    ]

    start_oban? =
      :backend
      |> Application.get_env(:jobs)
      |> Keyword.get(:start)
      |> Backend.Helpers.to_boolean()

    if start_oban? do
      Enum.reverse([{Oban, Application.get_env(:backend, Oban)} | base_children])
    else
      base_children
    end
  end
end
