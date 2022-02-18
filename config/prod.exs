import Config

config :fuschia, FuschiaWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :fuschia, :socket, check_origin: []

# Do not print debug messages in production
config :logger, level: :info
