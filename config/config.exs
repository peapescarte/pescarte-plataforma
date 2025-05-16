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

config :tailwind,
  version: "4.1.7",
  pescarte: [
    args: ~w(
      --input=assets/css/app.scss
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :esbuild,
  version: "0.25.0",
  pescarte: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
