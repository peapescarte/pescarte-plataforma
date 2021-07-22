import Config

config :fuschia, Fuschia.Repo,
  username: "pescarte",
  password: "pescarte",
  database: "fuschia_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fuschia, FuschiaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
