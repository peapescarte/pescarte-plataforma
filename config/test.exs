import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# ignore audit log by default
config :pescarte, carbonite_mode: :ignore

config :pescarte, Pescarte.Repo,
  username: "pescarte",
  password: "pescarte",
  database: "pescarte_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :pescarte, Oban, queues: false, plugins: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pescarte, PescarteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UMvQe3k+eH28J6exxhadrvKm+mIvF3n73YdsY6x7EZV7FJDRezMjvf/2reDRqkPJ",
  server: false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Print only warnings and errors during test
config :logger, level: :warn

try do
  import_config "local.secret.exs"
rescue
  _ -> nil
end
