import Config

# Configure your database
config :fuschia, Fuschia.Repo,
  username: "pescarte",
  password: "pescarte",
  database: "pescarte",
  hostname: "db",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :fuschia, FuschiaWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :git_hooks,
  auto_install: true,
  verbose: true,
  hooks: [
    pre_commit: [
      verbose: true,
      tasks: [
        {:cmd, "mix compile --warning-as-errors"},
        {:cmd, "mix format --check-formatted"}
      ]
    ],
    pre_push: [
      verbose: true,
      tasks: [
        {:cmd, "mix credo --strict"}
      ]
    ]
  ]

try do
  import_config "dev.secret.exs"
rescue
  _ -> nil
end
