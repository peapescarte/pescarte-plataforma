defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(nome)a

  schema "categoria" do
    field :nome, TrimmedString
    field :id_publico, :string

    has_many :tags, Tag

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def list_tags_query(%__MODULE__{} = categoria) do
    from t in Tag, where: t.categoria_id == ^categoria.id
  end
end
