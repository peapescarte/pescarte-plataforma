defmodule Pescarte.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria

  @type t :: %Tag{etiqueta: binary, id_publico: binary, categoria: Categoria.t()}

  @required_fields ~w(etiqueta categoria_nome)a

  @primary_key {:etiqueta, :string, autogenerate: false}
  schema "tag" do
    field(:id_publico, Pescarte.Database.Types.PublicId, autogenerate: true)

    belongs_to(:categoria, Categoria,
      foreign_key: :categoria_nome,
      references: :nome,
      type: :string
    )

    timestamps()
  end

  @spec changeset(Tag.t(), map) :: changeset
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:etiqueta)
    |> foreign_key_constraint(:categoria_nome)
  end
end
