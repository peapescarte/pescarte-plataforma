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
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.3.0"},
      {:ecto, "~> 3.10"},
      {:gen_stage, "~> 1.0"},
      {:floki, "~> 0.34.0"},
      {:explorer, "~> 0.5.0"},
      {:mox, "~> 1.0", only: :test},
      {:cotacoes, in_umbrella: true}
    ]
  end
end
