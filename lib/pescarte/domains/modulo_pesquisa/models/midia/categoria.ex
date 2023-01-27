defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  schema "categorias" do
    field :name, TrimmedString
    field :public_id, :string

    has_many :tags, Tag

    timestamps()
  end
end
