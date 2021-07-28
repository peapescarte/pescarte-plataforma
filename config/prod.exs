import Config

protocol =
  case System.get_env("ENABLE_HTTPS") do
    "true" -> [schema: "https", port: 443]
    _ -> [scheme: "http", port: 80]
  end

config :cors_plug,
  origin: ~r/https?.pea-pescarte\.uenf\.br$/

config :fuschia, FuschiaWeb.Endpoint,
  http: [port: System.get_env("PORT" || 80)],
  url: [host: System.get_env("FUSCHIA_HOST")] ++ protocol,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :fuschia, :socket, check_origin: []

# Do not print debug messages in production
config :logger, level: :info

config :fuschia, Fuschia.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

config :fuschia, Fuschia.Auth.Guardian, secret_key: System.get_env("GUARDIAN_SECRET_KEY")
