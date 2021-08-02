import Config

# ---------------------------#
# Guardian
# ---------------------------#
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
    "mailgun" -> Swoosh.Adapters.Mailgun
    "gmail" -> Swoosh.Adapters.SMTP
    _ -> Swoosh.Adapters.Local
  end

if adapter == Swoosh.Adapters.Local do
  config :swoosh, serve_mailbox: true, preview_port: 4001
end

config :fuschia, Mailer,
  adapter: adapter,
  domain: System.get_env("MAILGUN_DOMAIN", "email.uenf.br"),
  api_key: System.get_env("MAILGUN_PRIVATE_API_KEY"),
  base_url: System.get_env("MAILGUN_BASE_URL"),
  relay: System.get_env("MAIL_SERVER", "smtp.gmail.com"),
  username: System.get_env("MAIL_USERNAME", "notificacoes-noreply@peapescarte.uenf.br"),
  password: System.get_env("MAIL_PASSWORD", ""),
  ssl: false,
  tls: :always,
  auth: :always,
  port: System.get_env("MAIL_PORT", "587")

config :fuschia, :pea_pescarte_contact,
  notifications_mail: "notifications-noreply@peapescarte.uenf.br",
  telephone: "(11) 3038-1738"

# ---------------------------#
# Timex
# ---------------------------#
config :timex, timezone: System.get_env("TIMEZONE", "America/Sao_Paulo")
