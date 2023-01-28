defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  @types ~w(imagem video documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @types
    field :filename, TrimmedString
    field :filedate, :date
    field :sensible?, :boolean, default: false
    field :observation, TrimmedString
    field :link, TrimmedString
    field :alt_text, TrimmedString
    field :public_id, :string

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    many_to_many :tags, Tag, join_through: "midias_tags"

    timestamps()
  end

  def types, do: @types
end
