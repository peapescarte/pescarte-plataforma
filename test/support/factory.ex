defmodule Fuschia.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Fuschia.Repo

  use Fuschia.AuthLogFactory
  use Fuschia.ContatoFactory
  use Fuschia.UserFactory
end
