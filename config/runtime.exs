import Config

config :tesla, :adapter, {Tesla.Adapter.Finch, name: HttpClientFinch}

# ---------------------------#
# Logger
# ---------------------------#
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  backends: [:console, Sentry.LoggerBackend]

# ---------------------------#
# Guardian Auth
# ---------------------------#
config :fuschia, FuschiaWeb.Auth.Guardian,
  issuer: "pea_pescarte",
  ttl: {3, :days},
  secret_key: System.get_env("GUARDIAN_SECRET")

config :fuschia, FuschiaWeb.Auth.Pipeline,
  module: FuschiaWeb.Auth.Guardian,
  error_handler: FuschiaWeb.Auth.ErrorHandler

# ---------------------------#
# Sentry
# ---------------------------#
config :sentry,
  dsn: System.get_env("SENTRY_DNS"),
  environment_name: config_env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [System.get_env("SENTRY_ENV")]

# ---------------------------#
# Oban
# ---------------------------#
config :fuschia, Oban,
  repo: Fuschia.Repo,
  queues: [mailer: 5]

config :fuschia, :jobs, start: System.get_env("START_OBAN_JOBS", "true")

# ---------------------------#
# Mailer
# ---------------------------#
adapter =
  case System.get_env("MAIL_SERVICE", "local") do
    "gmail" -> Swoosh.Adapters.SMTP
    _ -> Swoosh.Adapters.Local
  end

if adapter == Swoosh.Adapters.Local do
  config :swoosh, serve_mailbox: true, preview_port: 4001
end

config :fuschia, Fuschia.Mailer,
  adapter: adapter,
  relay: System.get_env("MAIL_SERVER", "smtp.gmail.com"),
  username: System.get_env("MAIL_USERNAME", "notificacoes-noreply@peapescarte.uenf.br"),
  password: System.get_env("MAIL_PASSWORD", ""),
  ssl: false,
  tls: :always,
  auth: :always,
  port: System.get_env("MAIL_PORT", "587")

config :fuschia, :pea_pescarte_contact,
  notifications_mail: "notifications-noreply@peapescarte.uenf.br",
  telephone: " 0800 026 2828"

# ---------------------------#
# CORS
# ---------------------------#
config :cors_plug,
  headers: [
    "Authorization",
    "Content-Type",
    "Referer",
    "Accept",
    "Origin",
    "User-Agent",
    "Cache-Control",
    "Keep-Alive",
    "X-Api-Key"
  ]

# ---------------------------#
# Timex
# ---------------------------#
config :timex, timezone: System.get_env("TIMEZONE", "America/Sao_Paulo")

# ---------------------------#
# Phoenix
# ---------------------------#
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :fuschia, FuschiaWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :fuschia, Fuschia.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  protocol =
    case System.get_env("ENABLE_HTTPS") do
      "true" -> [schema: "https", port: 443]
      _ -> [scheme: "http", port: 80]
    end

  config :fuschia, FuschiaWeb.Endpoint,
    url: [host: host] ++ protocol,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
