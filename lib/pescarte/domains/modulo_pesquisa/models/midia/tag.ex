defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Types.TrimmedString

  alias __MODULE__

  @required_fields ~w(label categoria_id)a

  schema "tags" do
    field :label, TrimmedString
    field :public_id, :string

    belongs_to :categoria, Categoria

    timestamps()
  end

  def changeset(tag \\ %__MODULE__{}, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:label)
    |> foreign_key_constraint(:categoria_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  def list_by_query(fields) do
    from t in Tag, where: t.id in ^fields
  end

  def list_midias_query(tag = %__MODULE__{}) do
    from t in Tag, where: t.id == ^tag.id, preload: :midias
  end
end
