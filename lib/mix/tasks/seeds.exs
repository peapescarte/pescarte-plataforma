defmodule Fuschia.Tasks.Seeds do
  @moduledoc """
  Seeds for Fuschia database
  """

  if Mix.env() in [:dev, :test] do
    Fuschia.ApiKeysDevSeeds.run()
  end
end
