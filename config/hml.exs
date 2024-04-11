import Config

config :pescarte, :pesquisa_ingestion, sheet_url: System.get_env("SHEET_URL")

database_user = System.fetch_env!("DATABASE_USER")
database_pass = System.fetch_env!("DATABASE_PASS")
database_name = System.fetch_env!("DATABASE_NAME")
database_host = System.fetch_env!("DATABASE_HOST")

config :pescarte, Pescarte.Database.Repo,
  hostname: database_host,
  username: database_user,
  password: database_pass,
  database: database_name,
  stacktrace: false,
  pool_size: 15

config :pescarte, Pescarte.Database.Repo.Replica,
  hostname: database_host,
  username: database_user,
  password: database_pass,
  database: database_name,
  stacktrace: false,
  pool_size: 5
