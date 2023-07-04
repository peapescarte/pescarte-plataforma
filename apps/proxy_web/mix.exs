defmodule ProxyWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :proxy_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [mod: {ProxyWeb, []}, extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bandit, "~> 0.6"},
      {:phoenix, "~> 1.7", override: true},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plataforma_digital, in_umbrella: true},
      {:plataforma_digital_api, in_umbrella: true}
    ]
  end
end
