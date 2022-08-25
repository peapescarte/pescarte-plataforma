defmodule Fuschia.ModuloPesquisa.Models.Cidade do
  @moduledoc """
  Cidade schema
  """

  use Fuschia, :model

  alias Fuschia.ModuloPesquisa.Models.Campus

  @primary_key {:id, :string, autogenerate: false}
  schema "cidade" do
    field :municipio, CapitalizedString

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end
end
