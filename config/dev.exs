import Config

# -------- #
# Database #
# -------- #
database = "peapescarte_dev"
db_user = System.get_env("DATABASE_USER", "pescarte")
db_pass = System.get_env("DATABASE_PASSWORD", "pescarte")

database_opts = [
  username: db_user,
  password: db_pass,
  hostname: "localhost",
  database: database,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
]

config :database, Database.EscritaRepo, database_opts
config :database, Database.LeituraRepo, database_opts

# --------- #
# Proxy Web #
# --------- #
config :proxy_web, ProxyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  reloadable_compilers: [:elixir],
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
    sass: {DartSass, :install_and_run, [:default, ~w(--watch)]},
    storybook_tailwind: {Tailwind, :install_and_run, [:storybook, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"storybook/.*(exs)$",
      ~r"apps/plataforma_digital_api/lib/*.(ex)$",
      ~r"apps/plataforma_digital/priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"apps/plataforma_digital/lib/plataforma_digital/(controllers|live|components|templates)/.*(ex|heex)$"
    ]
  ]

config :plataforma_digital, PlataformaDigital.Endpoint, debug_errors: true
config :plataforma_digital_api, PlataformaDigitalAPI.Endpoint, debug_errors: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
