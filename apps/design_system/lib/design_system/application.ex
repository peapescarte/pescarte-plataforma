defmodule DesignSystem.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [DesignSystem.Endpoint]
    opts = [strategy: :one_for_one, name: DesignSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    DesignSystem.Endpoint.config_change(changed, removed)
    :ok
  end
end
