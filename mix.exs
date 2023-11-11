defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      app: :pescarte,
      version: "0.1.0",
      deps: deps(),
      aliases: aliases(),
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [mod: {Pescarte.Application, []}, extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(e) when e in ~w(dev test)a, do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 0.6"},
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.16"},
      {:unzip, "~> 0.8"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:ex_machina, "~> 2.7.0"},
      {:nanoid, "~> 2.0.5"},
      {:bcrypt_elixir, "~> 2.0"},
      {:brcpfcnpj, "~> 1.0.0"},
      {:timex, "~> 3.0"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18"},
      {:floki, ">= 0.30.0"},
      {:jason, "~> 1.0"},
      {:lucide_icons, "~> 1.0"},
      {:absinthe, "~> 1.5"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0.0"},
      {:phoenix_storybook, "~> 0.5"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "> 0.0.0", only: [:dev, :test], runtime: false},
      {:git_hooks, "~> 0.4.0", only: [:test, :dev], runtime: false}
    ]
  end

  defp aliases do
    [
      dev: ["setup", "phx.server"],
      setup: ["deps.get", "ecto.setup", "seed"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
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
