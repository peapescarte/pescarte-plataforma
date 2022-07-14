defmodule Fuschia.MixProject do
  use Mix.Project

  def project do
    [
      app: :fuschia,
      version: "0.0.1",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      compilers: [:phoenix] ++ Mix.compilers(),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      # Documentação
      name: "Fuschia",
      source_url: "https://github.com/cciuenf/fuschia",
      homepage_url: "",
      docs: [
        main: "Fuschia",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      mod: {Fuschia.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"] ++ catalogues()
  defp elixirc_paths(_), do: ["lib"]

  defp catalogues do
    [
      "priv/catalogue"
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.6.6"},
      {:phoenix_ecto, "~> 4.1"},
      {:swoosh, "~> 1.4"},
      {:mail, ">= 0.0.0"},
      {:brcpfcnpj, "~> 1.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:floki, ">= 0.30.0", only: :test},
      {:bcrypt_elixir, "~> 2.0"},
      {:paginator, "~> 1.0.3"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:ecto_sql, "~> 3.4"},
      {:oban, "~> 2.8"},
      {:proper_case, "~> 1.0.2"},
      {:nanoid, "~> 2.0.5"},
      {:hackney, "~> 1.8"},
      {:timex, "~> 3.0"},
      {:guardian, "~> 2.0"},
      {:ex_machina, "~> 2.7.0"},
      {:cors_plug, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "~> 8.0"},
      {:carbonite, "~> 0.4.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:jason, "~> 1.0"},
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.9.0"},
      {:plug_cowboy, "~> 2.3"},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev}
    ]
  end

  defp aliases do
    [
      ci: ["format --check-formatted", "credo --strict", "test"],
      setup: ["deps.get", "ecto.setup", "dialyzer --format dialyxir"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run lib/mix/tasks/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "run lib/mix/tasks/seeds.exs", "test"],
      "test.reset": ["ecto.drop", "test"],
      "assets.deploy": [
        "esbuild default --minify",
        "tailwind default --minify",
        "phx.digest"
      ]
    ]
  end
end
