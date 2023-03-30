import Config

config :pescarte, env: config_env()

config :pescarte, carbonite_mode: :capture

# ---------------------------#
# Ecto
# ---------------------------#
config :pescarte,
  ecto_repos: [Pescarte.Repo]

config :pescarte, Pescarte.Repo, migration_timestamps: [type: :utc_datetime_usec]

# ---------------------------#
# Endpoint
# ---------------------------#
config :pescarte, PescarteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/tnqEz6BgkvSQoZdVePI7wI2tB6enxAPY66OSNNCGSeDy2VkzG0lIc/cguFxfA+0",
  render_errors: [view: PescarteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pescarte.PubSub

# ---------------------------#
# Phoenix
# ---------------------------#
config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
