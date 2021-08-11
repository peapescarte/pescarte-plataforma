defmodule Fuschia.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Fuschia.Repo

  use Fuschia.AuthLogFactory
  use Fuschia.CidadeFactory
  use Fuschia.ContatoFactory
  use Fuschia.LinhaPesquisaFactory
  use Fuschia.NucleoFactory
  use Fuschia.PesquisadorFactory
  use Fuschia.UserFactory
  use Fuschia.UniversidadeFactory
end
