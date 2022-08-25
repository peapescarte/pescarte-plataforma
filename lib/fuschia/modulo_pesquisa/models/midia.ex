defmodule Fuschia.ModuloPesquisa.Models.Midia do
  @moduledoc """
  Midia Schema
  """

  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.Types.TrimmedString

  @tipos_midia ~w(video imagem documento)a

  @primary_key {:id, :string, autogenerate: false}
  schema "midia" do
    field :tipo, Ecto.Enum, values: @tipos_midia
    field :link, TrimmedString
    field :tags, {:array, TrimmedString}

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end
end
