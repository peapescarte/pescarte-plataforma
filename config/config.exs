import Config

config :pescarte, env: config_env()

config :pescarte, PescarteWeb,
  notice_title_max_length: 110,
  notice_desc_max_length: 145

config :tesla, adapter: {Tesla.Adapter.Finch, name: PescarteHTTPClient}

config :flop, repo: Pescarte.Database.Repo.Replica

config :pescarte, fetch_pesagro_cotacoes: !!System.get_env("FETCH_PESAGRO_COTACOES")

config :pescarte, PescarteWeb, sender_email: "plataforma-pescarte@noreply.pescarte.org.br"
config :pescarte, PescarteWeb, receiver_email: "criativo.pescarte@uenf.br"

config :pescarte,
  ecto_repos: [Pescarte.Database.Repo],
  migration_timestamps: [type: :utc_datetime_usec]

config :pescarte, PescarteWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  secret_key_base: "yFgelUyKSgiemxYRsbxwGxiQKROQTx0bokxUGNZOnOOqJExsqZSsUHmcq4Ue11Tx",
  pubsub_server: Pescarte.PubSub,
  render_errors: [formats: [html: PescarteWeb.ErrorHTML], layout: false],
  live_view: [signing_salt: "TxTzLCT/WGlob2+Vo0uZ1IQAfkgq53M"],
  server: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
