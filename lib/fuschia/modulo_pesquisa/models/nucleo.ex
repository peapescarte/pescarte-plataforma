defmodule Fuschia.ModuloPesquisa.Models.Nucleo do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa

  @primary_key {:id, :string, autogenerate: false}
  schema "core" do
    field :nome, CapitalizedString
    field :desc, :string

    has_many :linhas, LinhaPesquisa

    timestamps()
  end
end
