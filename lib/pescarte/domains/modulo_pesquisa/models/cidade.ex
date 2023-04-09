defmodule Pescarte.Domains.ModuloPesquisa.Models.Cidade do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  schema "cidade" do
    field :county, CapitalizedString
    field :public_id, :string

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:county])
    |> validate_required([:county])
    |> unique_constraint(:county)
    |> put_change(:public_id, Nanoid.generate())
    |> apply_action(:parse)
  end
end
