defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(label categoria_id)a

  schema "tags" do
    field :label, TrimmedString
    field :public_id, :string

    belongs_to :categoria, Categoria

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:label)
    |> foreign_key_constraint(:categoria_id)
    |> put_change(:public_id, Nanoid.generate())
  end
end
