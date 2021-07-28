defmodule Fuschia.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: V1.Repo

  use Fuschia.AuthLogFactory
end
