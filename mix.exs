defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      app: :pescarte,
      version: "0.0.1",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      elixirc_options: [warnings_as_errors: false],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: ["test.reset": :test]
    ]
  end

  def application do
    [
      mod: {Pescarte.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:swoosh, "~> 1.4"},
      {:mail, ">= 0.0.0"},
      {:brcpfcnpj, "~> 1.0.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:bcrypt_elixir, "~> 2.0"},
      {:bandit, "~> 0.6"},
      {:ecto_sql, "~> 3.4"},
      {:nanoid, "~> 2.0.5"},
      {:hackney, "~> 1.8"},
      {:timex, "~> 3.0"},
      {:ex_machina, "~> 2.7.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:phoenix_live_view, "~> 0.18"},
      {:floki, ">= 0.30.0", only: :test},
      {:jason, "~> 1.0"},
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.9.0"},
      {:absinthe, "~> 1.5"},
      {:absinthe_error_payload, "~> 1.0"},
      {:lucide_icons, "~> 1.0"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0.0"},
      {:phoenix_storybook, "~> 0.5.0"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      ci: ["format --check-formatted", "credo --strict", "test"],
      setup: ["deps.get", "ecto.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seeds"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.reset": ["ecto.drop", "test"],
      "assets.build": [
        "esbuild default",
        "sass default",
        "tailwind default",
        "tailwind storybook"
      ],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default",
        "tailwind default --minify",
        "tailwind storybook --minify",
        "phx.digest"
      ]
    ]
  end
end
