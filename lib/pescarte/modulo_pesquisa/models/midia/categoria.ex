defmodule Pescarte.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag

  @type t :: %Categoria{nome: binary, id: binary, tags: list(Tag.t())}

  @required_fields ~w(nome)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "categoria" do
    field :nome, :string

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
