defmodule Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  schema "nucleo_pesquisa" do
    field :name, CapitalizedString
    field :letter, CapitalizedString
    field :desc, :string
    field :public_id, :string

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :desc, :letter])
    |> validate_required([:name, :desc, :letter])
    |> validate_length(:desc, max: 400)
    |> put_change(:public_id, Nanoid.generate())
    |> apply_action(:parse)
  end

  def update_changeset(nucleo_pesquisa, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:desc])
    |> validate_required([:desc])
    |> apply_action(:parse)
  end
end
