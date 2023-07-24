defmodule Seeder.MixProject do
  use Mix.Project

  def project do
    [
      app: :seeder,
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
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:nanoid, "~> 2.0.5"},
      {:database, in_umbrella: true},
      {:identidades, in_umbrella: true},
      {:modulo_pesquisa, in_umbrella: true}
    ]
  end
end
