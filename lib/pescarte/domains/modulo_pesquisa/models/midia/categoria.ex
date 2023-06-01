defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @type t :: %Categoria{id: integer, nome: binary, id_publico: binary, tags: list(Tag.t())}

  @required_fields ~w(nome)a

  schema "categoria" do
    field :nome, :string
    field :id_publico, :string

    has_many :tags, Tag

    timestamps()
  end

  @spec changeset(struct, map) :: {:ok, Categoria.t()} | {:error, changeset}
  def changeset(categoria \\ %__MODULE__{}, attrs) do
    categoria
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end
end
