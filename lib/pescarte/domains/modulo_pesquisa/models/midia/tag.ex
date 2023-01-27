defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Types.TrimmedString

  schema "tags" do
    field :label, TrimmedString
    field :public_id, :string

    belongs_to :categoria, Categoria
  end
end
