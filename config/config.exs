import Config

config :pescarte, env: config_env()

config :pescarte, PescarteWeb,
  notice_title_max_length: 110,
  notice_desc_max_length: 145

config :supabase_gotrue,
  endpoint: PescarteWeb.Endpoint,
  signed_in_path: "/app/pesquisa/perfil",
  not_authenticated_path: "/acessar",
  authentication_client: Pescarte.Supabase.Auth

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
