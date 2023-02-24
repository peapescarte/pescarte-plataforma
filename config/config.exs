import Config

config :pescarte, env: config_env()

config :pescarte, carbonite_mode: :capture

# ---------------------------#
# Ecto
# ---------------------------#
config :pescarte,
  ecto_repos: [Pescarte.Repo]

config :pescarte, Pescarte.Repo, migration_timestamps: [type: :utc_datetime_usec]

# ---------------------------#
# Endpoint
# ---------------------------#
config :pescarte, PescarteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/tnqEz6BgkvSQoZdVePI7wI2tB6enxAPY66OSNNCGSeDy2VkzG0lIc/cguFxfA+0",
  render_errors: [view: PescarteWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pescarte.PubSub,
  live_view: [signing_salt: "Fz4O74-XJOgrKgnj"]

# ---------------------------#
# Phoenix
# ---------------------------#
config :phoenix, :json_library, Jason

# ---------------------------#
# Esbuild
# ---------------------------#

if esbuild_path = System.get_env("ESBUILD_PATH") do
  config :esbuild, path: esbuild_path
end

if tailwind_path = System.get_env("TAILWINDCSS_PATH") do
  config :tailwind, path: esbuild_path
end

if sass_path = System.get_env("SASS_PATH") do
  config :dart_sass, path: esbuild_path
end

config :esbuild,
  version: "0.17.5",
  default: [
    args: ~w(js/app.js --bundle --platform=node --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.57.1",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args:
      ~w(--config=tailwind.config.js --input=../priv/static/assets/app.css.tailwind --output=../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
