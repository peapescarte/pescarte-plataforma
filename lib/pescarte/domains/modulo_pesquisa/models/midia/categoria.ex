defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @type t :: %Categoria{id: integer, nome: binary, id_publico: binary, tags: list(Tag.t())}

  @required_fields ~w(nome)a

  schema "categoria" do
    field :nome, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true

    has_many :tags, Tag

    timestamps()
  end

  @spec changeset(Categoria.t(), map) :: changeset
  def changeset(%Categoria{} = categoria, attrs) do
    categoria
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
  end
end
