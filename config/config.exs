import Config

config :pescarte, env: config_env()

config :tesla, adapter: {Tesla.Adapter.Finch, name: PescarteHTTPClient}

config :flop, repo: Pescarte.Database.Repo.Replica

config :pescarte, fetch_pesagro_cotacoes: System.get_env("FETCH_PESAGRO_COTACOES")

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

config :esbuild,
  version: "0.18.6",
  default: [
    args:
      ~w(js/app.js --bundle --platform=node --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.63.6",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tailwind,
  version: "3.3.2",
  default: [
    args:
      ~w(--config=tailwind.config.js --input=../priv/static/assets/app.css.tailwind --output=../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :git_hooks,
  verbose: false,
  auto_install: true,
  branches: [
    whitelist: ["main"]
  ],
  hooks: [
    pre_push: [
      tasks: [
        "mix clean",
        "mix compile --warning-as-errors",
        "mix format --check-formatted",
        "mix credo --strict",
        "mix test --only unit",
        "mix test --only integration"
      ]
    ]
  ]

import_config "#{config_env()}.exs"
