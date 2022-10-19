import Config

# Configure your database
config :fuschia, Fuschia.Repo,
  username: "pescarte",
  password: "pescarte",
  database: "fuschia_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :fuschia, FuschiaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "vr3C1ik7ud2WY6W8zsvLj6vSSTQzy1aaazzt41vG/yEETXMPw0mKne/2KnJjeiSy",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    esbuild: {Esbuild, :install_and_run, [:catalogue, ~w(--sourcemap=inline --watch)]}
  ]

config :fuschia, FuschiaWeb.Endpoint,
  reloadable_compilers: [:elixir, :surface],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/my_app_web/(live|views|components)/.*(ex|sface|js)$",
      ~r"lib/my_app_web/templates/.*(eex|sface)$",
      ~r"priv/catalogue/.*(ex)$"
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
