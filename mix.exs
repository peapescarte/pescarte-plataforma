defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        pescarte: [
          applications: [
            database: :permanent,
            cotacoes: :permanent,
            proxy_web: :permanent,
            identidades: :permanent,
            modulo_pesquisa: :permanent,
            plataforma_digital: :permanent,
            plataforma_digital_api: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      dev: ["setup", "phx.server"],
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "database.migrate"],
      test: ["ecto.create --quiet", "database.migrate --quiet", "test"],
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
