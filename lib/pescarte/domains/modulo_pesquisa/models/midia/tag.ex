defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  @type t :: %Tag{id: integer, etiqueta: binary, id_publico: binary, categoria: Categoria.t()}

  @required_fields ~w(etiqueta categoria_id)a

  schema "tag" do
    field :etiqueta, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true

    belongs_to :categoria, Categoria

    timestamps()
  end

  @spec changeset(Tag.t(), map) :: changeset
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:etiqueta)
    |> foreign_key_constraint(:categoria_id)
  end
end
