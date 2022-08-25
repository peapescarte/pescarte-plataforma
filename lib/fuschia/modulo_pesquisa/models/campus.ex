defmodule Fuschia.ModuloPesquisa.Models.Campus do
  @moduledoc """
  Campus Schema
  """

  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.Cidade
  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.Types.TrimmedString

  @primary_key {:id, :string, autogenerate: false}
  schema "campus" do
    field :nome, TrimmedString
    field :sigla, TrimmedString

    belongs_to :cidade, Cidade, on_replace: :delete

    has_many :pesquisadores, Pesquisador

    timestamps()
  end
end
