import Config

config :timex, timezone: System.get_env("TIMEZONE", "America/Sao_Paulo")

if System.get_env("PHX_SERVER") do
  config :pescarte, PescarteWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  database_opts = [
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
  ]

  config :pescarte, Pescarte.Database.Repo, database_opts
  config :pescarte, Pescarte.Database.Repo.Replica, database_opts

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE not available"

  config :pescarte, PescarteWeb.Endpoint,
    secret_key_base: secret_key_base,
    url: [host: "pescarte.org.br"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ]
end
