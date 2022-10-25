import Config

config :pescarte, PescarteWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
