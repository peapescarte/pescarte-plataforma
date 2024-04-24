import Config

config :pescarte, ecto_repos: [Pescarte.Database.Repo]

db_user = System.get_env("DATABASE_USER", "peapescarte")
db_pass = System.get_env("DATABASE_PASS", "peapescarte")
db_port = System.get_env("DATABASE_PORT", "5432")
db_host = System.get_env("DATABASE_HOST", "localhost")

database_opts = [
  username: db_user,
  password: db_pass,
  hostname: db_host,
  port: String.to_integer(db_port),
  database: "peapescarte_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
]

config :pescarte, Pescarte.Database.Repo, database_opts

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pescarte, PescarteWeb.Endpoint, server: false

# Print only warnings and errors during test
config :logger, level: :warning
