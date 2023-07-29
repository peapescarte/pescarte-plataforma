defmodule Pescarte.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      name: :pescarte,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        pescarte: [
          strip_beams: true,
          cookie: Base.url_encode64(:crypto.strong_rand_bytes(40)),
          validate_compile_env: true,
          quiet: true,
          include_erts: true,
          include_executables_for: [:unix],
          applications: [
            proxy_web: :permanent,
            modulo_pesquisa: :permanent,
            identidades: :permanent,
            cotacoes: :permanent,
            seeder: :load
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
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
