defmodule Fuschia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, list) :: {:ok, pid} | {:error, any}
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Fuschia.Supervisor]

    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(keyword, keyword, keyword) :: :ok
  def config_change(changed, _new, removed) do
    FuschiaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    base_children = [
      # Start the Ecto repository
      Fuschia.Repo,
      # Start the Telemetry supervisor
      FuschiaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fuschia.PubSub},
      # Start the Endpoint (http/https)
      FuschiaWeb.Endpoint,
      # Start external http client
      {Finch, name: HttpClientFinch, pools: %{default: [size: 10]}}
      # Start Oban jobs
    ]

    start_oban? =
      :fuschia
      |> Application.get_env(:jobs)
      |> Keyword.get(:start)
      |> Fuschia.Helpers.to_boolean()

    if start_oban? do
      Enum.reverse([{Oban, Application.get_env(:fuschia, Oban)} | base_children])
    else
      base_children
    end
  end
end
