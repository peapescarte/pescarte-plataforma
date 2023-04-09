defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(name)a

  schema "categorias" do
    field :name, TrimmedString
    field :public_id, :string

    has_many :tags, Tag

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> put_change(:public_id, Nanoid.generate())
  end

  def list_tags_query(categoria = %__MODULE__{}) do
    from t in Tag, where: t.categoria_id == ^categoria.id
  end
end
