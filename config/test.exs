import Config

config :database, ecto_repos: [Database.Repo]

database_opts = [
  username: System.get_env("DATABASE_USER", "pescarte"),
  password: System.get_env("DATABASE_PASSWORD", "pescarte"),
  database: "peapescarte_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
]

config :database, Database.Repo, database_opts

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plataforma_digital, PlataformaDigital.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bCQ+FSLb9dhw6zg5bmUdKpINI8n7gjfzV84iFV9bLS9xd3rMIG20f5vXkkwbunnG",
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plataforma_digital_api, PlataformaDigitalAPI.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  secret_key_base: "KGsxlyxraEpvmC3fdae4QTZ0qd0ahZSKK8I/9wVxo4r5N+wAU8Z6qgYTIErGKkpI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1
