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
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Fuschia.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:paginator, "~> 1.0.3"},
      {:ecto_sql, "~> 3.4"},
      {:proper_case, "~> 1.0.2"},
      {:hackney, "~> 1.8"},
      {:timex, "~> 3.0"},
      {:guardian, "~> 2.0"},
      {:ex_machina, "~> 2.7.0"},
      {:cors_plug, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:open_api_spex, "~> 3.10"},
      {:sentry, "~> 8.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.3"},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.6.3", only: [:dev], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      ci: ["format --check-formatted", "credo --strict", "test"],
      setup: ["deps.get", "ecto.setup", "dialyzer --format dialyxir"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
