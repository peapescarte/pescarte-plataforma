import Config

# ---------------------------#
# Ecto
# ---------------------------#
config :fuschia,
  ecto_repos: [Fuschia.Repo]

config :fuschia, Fuschia.Repo,
  migration_timestamps: [inserted_at: :created_at, type: :utc_datetime_usec]

# ---------------------------#
# Endpoint
# ---------------------------#
config :fuschia, FuschiaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/tnqEz6BgkvSQoZdVePI7wI2tB6enxAPY66OSNNCGSeDy2VkzG0lIc/cguFxfA+0",
  render_errors: [view: FuschiaWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Fuschia.PubSub,
  live_view: [signing_salt: "kHky3tuz"]

# ---------------------------#
# Phoenix
# ---------------------------#
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
