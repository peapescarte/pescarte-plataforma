import Config

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
