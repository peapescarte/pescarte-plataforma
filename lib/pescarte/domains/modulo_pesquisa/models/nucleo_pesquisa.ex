defmodule Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  schema "nucleo_pesquisa" do
    field :nome, CapitalizedString
    field :letra, CapitalizedString
    field :desc, :string
    field :id_publico, :string

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:nome, :desc, :letra])
    |> validate_required([:nome, :desc, :letra])
    |> validate_length(:desc, max: 400)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def update_changeset(nucleo_pesquisa, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:desc])
    |> validate_required([:desc])
  end
end
