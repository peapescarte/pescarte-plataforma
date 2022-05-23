import Config

config :gettext, default_locale: "pt_BR"

config :fuschia, carbonite_mode: :capture

# ---------------------------#
# Ecto
# ---------------------------#
config :fuschia,
  ecto_repos: [Fuschia.Repo]

config :fuschia, Fuschia.Repo, migration_timestamps: [type: :utc_datetime_usec]

# ---------------------------#
# Endpoint
# ---------------------------#
config :fuschia, FuschiaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/tnqEz6BgkvSQoZdVePI7wI2tB6enxAPY66OSNNCGSeDy2VkzG0lIc/cguFxfA+0",
  render_errors: [view: FuschiaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fuschia.PubSub,
  live_view: [signing_salt: "kHky3tuz"]

# ---------------------------#
# Phoenix
# ---------------------------#
config :phoenix, :json_library, Jason

config :surface, :components, [
  {Surface.Components.Form.ErrorTag,
   default_translator: {FuschiaWeb.ErrorHelpers, :translate_error}}
]

# ---------------------------#
# Esbuild
# ---------------------------#
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --platform=node --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --external:/icons/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
