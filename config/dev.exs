import Config

# Configure your database
config :pescarte, Pescarte.Repo,
  username: System.fetch_env!("PGUSER"),
  password: System.get_env("PGPASSSWORD", ""),
  database: "pescarte_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :pescarte, PescarteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "vr3C1ik7ud2WY6W8zsvLj6vSSTQzy1aaazzt41vG/yEETXMPw0mKne/2KnJjeiSy"

config :pescarte, PescarteWeb.Endpoint,
  reloadable_compilers: [:elixir],
  live_reload: [
    patterns: [
      ~r"lib/pescarte_web/graphql/.*(ex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

try do
  import_config "local.secret.exs"
rescue
  _ -> nil
end
