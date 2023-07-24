defmodule CotacoesETL.MixProject do
  use Mix.Project

  def project do
    [
      app: :cotacoes_etl,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CotacoesETL.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.16"},
      {:jason, ">= 1.0.0"},
      {:ecto, "~> 3.10"},
      {:floki, "~> 0.34.0"},
      {:explorer, "~> 0.5.0"},
      {:unzip, "~> 0.8"},
      {:nimble_parsec, "~> 1.3"},
      {:mox, "~> 1.0", only: :test},
      {:cotacoes, in_umbrella: true},
      {:database, in_umbrella: true}
    ]
  end
end
