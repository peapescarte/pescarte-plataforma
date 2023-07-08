import Config

config :database, config_env: config_env()

config :tesla, adapter: {Tesla.Adapter.Finch, name: PescarteHTTPClient}

# -------- #
# Database #
# -------- #
config :database,
  ecto_repos: [Database.Repo, Database.Repo.Replica],
  migration_timestamps: [type: :utc_datetime_usec]

# --------- #
# Proxy Web #
# --------- #
config :proxy_web, ProxyWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: Pescarte.PubSub,
  url: [host: "localhost"],
  secret_key_base: "57RgSOwri8BGRx6ilgBZjAf3Cob5s8/2E4CFkr+/FWZGEP0J2f+AWFnUKn2QGlvf",
  server: true

# ------------------- #
# Plataforma Digitial #
# ------------------- #
config :plataforma_digital, PlataformaDigital.Endpoint,
  secret_key_base: "yFgelUyKSgiemxYRsbxwGxiQKROQTx0bokxUGNZOnOOqJExsqZSsUHmcq4Ue11Tx",
  pubsub_server: Pescarte.PubSub,
  render_errors: [formats: [html: PlataformaDigital.ErrorHTML], layout: false],
  live_view: [signing_salt: "TxTzLCT/WGlob2+Vo0uZ1IQAfkgq53M"],
  server: false

config :esbuild,
  version: "0.18.6",
  default: [
    args:
      ~w(js/app.js js/storybook.js --bundle --platform=node --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../apps/plataforma_digital/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.63.6",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../apps/plataforma_digital/assets", __DIR__)
  ]

config :tailwind,
  version: "3.3.2",
  default: [
    args:
      ~w(--config=tailwind.config.js --input=../priv/static/assets/app.css.tailwind --output=../priv/static/assets/app.css),
    cd: Path.expand("../apps/plataforma_digital/assets", __DIR__)
  ],
  storybook: [
    args: ~w(
          --config=tailwind.config.js
          --input=css/storybook.css
          --output=../priv/static/assets/storybook.css
        ),
    cd: Path.expand("../apps/plataforma_digital/assets", __DIR__)
  ]

# ---------------------- #
# Plataforma Digital API #
# ---------------------- #
config :plataforma_digital_api, PlataformaDigitalAPI.Endpoint,
  pubsub_server: Pescarte.PubSub,
  secret_key_base: "p72JmdAzMY6LcSoQVEFDujKltZoaqCVTu5T5Fj/8PQzc079nuVa1kQfr4Z5lmJUE",
  server: false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :seeder, env: config_env()

import_config "#{config_env()}.exs"
