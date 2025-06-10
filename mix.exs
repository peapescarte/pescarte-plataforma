defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      app: :pescarte,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      releases: [
        pescarte: [
          strip_beams: true,
          validate_compile_env: true,
          quiet: true,
          include_erts: true,
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  def cli do
    [preferred_envs: [seed: :test]]
  end

  def application do
    [mod: {Pescarte.Application, []}, extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 1.6"},
      {:nanoid, "~> 2.0"},
      {:brcpfcnpj, "~> 1.0.0"},
      {:tesla, "~> 1.13"},
      {:req, "~> 0.5"},
      {:finch, "~> 0.19"},
      {:jason, "~> 1.4"},
      {:ecto, "~> 3.12"},
      {:unzip, "~> 0.8"},
      {:bcrypt_elixir, "~> 3.1"},
      {:nimble_parsec, "~> 1.3"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:ex_machina, "~> 2.7.0"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:floki, ">= 0.30.0"},
      {:lucide_icons, "~> 2.0"},
      {:hackney, "~> 1.20"},
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0.0"},
      {:chromic_pdf, "~> 1.15"},
      {:gettext, "~> 0.24"},
      {:explorer, "~> 0.8.1"},
      {:swiss_schema, "~> 0.5"},
      {:supabase_potion,
       git: "https://github.com/supabase-community/supabase-ex.git",
       branch: "main",
       override: true},
      {:supabase_gotrue, github: "supabase-community/auth-ex"},
      {:supabase_storage, github: "supabase-community/storage-ex"},
      {:flop, "~> 0.26"},
      {:flop_phoenix, "~> 0.23"},
      {:resend, "~> 0.4.0"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:nimble_csv, "~> 1.1"},
      {:sentry, "~> 10.8"},
      {:earmark, "~> 1.4"},
      {:mox, "~> 1.0", only: [:test]},
      {:rewire, "~> 0.9", only: [:test]},
      {:faker, "~> 0.18", only: :test},
      {:dialyxir, "~> 1.3", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "> 0.0.0", only: :dev, runtime: false},
      {:git_hooks, "~> 0.8.0-pre0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      dev: ["cmd --cd assets npm ci", "assets.build", "setup", "phx.server"],
      setup: ["git_hooks.install --quiet", "deps.get", "ecto.setup", "seed"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup", "seed"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.build": ["cmd --cd assets node build.js"],
      "assets.deploy": ["cmd --cd assets node build.js --deploy", "phx.digest"],
      lint: ["compile --warning-as-errors", "clean", "format --check-formatted", "credo --strict"],
      "ci.check": ["lint", "test --only unit", "test --only integration"]
    ]
  end
end
