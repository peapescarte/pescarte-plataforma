defmodule Pescarte.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria

  @type t :: %Tag{etiqueta: binary, id: binary, categoria: Categoria.t()}

  @required_fields ~w(etiqueta categoria_id)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "tag" do
    field :etiqueta, :string

    belongs_to :categoria, Categoria, type: :string

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
