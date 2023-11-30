defmodule Pescarte.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.ModuloPesquisa.Models.Midia.Tag

  @type t :: %Categoria{nome: binary, id_publico: binary, tags: list(Tag.t())}

  @required_fields ~w(nome)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "categoria" do
    field :id_publico, Pescarte.Database.Types.PublicId, autogenerate: true

    has_many :tags, Tag, foreign_key: :categoria_nome, references: :nome

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
