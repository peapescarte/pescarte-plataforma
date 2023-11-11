import Config

config :pescarte, config_env: Mix.env()

config :pescarte, fetch_pesagro_cotacoes: System.get_env("FETCH_PESAGRO_COTACOES")

config :tesla, adapter: {Tesla.Adapter.Finch, name: PescarteHTTPClient}

config :pescarte,
  ecto_repos: [Pescarte.Database.Repo, Pescarte.Database.Repo.Replica],
  migration_timestamps: [type: :utc_datetime_usec]

config :pescarte, PescarteWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: Pescarte.PubSub,
  url: [host: "localhost"],
  render_errors: [
    layout: false,
    formats: [html: PescarteWeb.ErrorHTML, json: PescarteWeb.ErrorJSON]
  ],
  secret_key_base: "57RgSOwri8BGRx6ilgBZjAf3Cob5s8/2E4CFkr+/FWZGEP0J2f+AWFnUKn2QGlvf",
  server: true,
  live_view: [signing_salt: "F5ab1yDTPHX_hQJm"]

config :esbuild,
  version: "0.18.6",
  default: [
    args:
      ~w(js/app.js js/storybook.js --bundle --platform=node --target=es2017 --outdir=../priv/static/assets),
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
  ],
  storybook: [
    args: ~w(
          --config=tailwind.config.js
          --input=css/storybook.css
          --output=../priv/static/assets/storybook.css
        ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :git_hooks,
  verbose: true,
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
