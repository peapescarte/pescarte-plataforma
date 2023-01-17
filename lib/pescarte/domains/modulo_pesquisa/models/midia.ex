defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @midia_types ~w(video imagem documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @midia_types
    field :link, TrimmedString
    field :public_id, :string

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end
end
