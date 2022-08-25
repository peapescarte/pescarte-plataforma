defmodule Fuschia.ModuloPesquisa.Models.Relatorio do
  @moduledoc """
  Relatorio Schema
  """

  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.Types.TrimmedString

  @tipos ~w(mensal trimestral anual)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "relatorio" do
    field :ano, :integer
    field :mes, :integer
    field :tipo, Ecto.Enum, values: @tipos
    field :link, TrimmedString
    field :raw_content, TrimmedString

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end
end
