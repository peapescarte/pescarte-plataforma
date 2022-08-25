defmodule Fuschia.ModuloPesquisa.Models.LinhaPesquisa do
  @moduledoc """
  LinhaPesquisa schema
  """
  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.Nucleo
  alias Fuschia.Types.TrimmedString

  @primary_key {:id, :string, autogenerate: false}
  schema "linha_pesquisa" do
    field :numero, :integer
    field :descricao_curta, TrimmedString
    field :descricao_longa, TrimmedString

    belongs_to :nucleo, Nucleo

    timestamps()
  end
end
