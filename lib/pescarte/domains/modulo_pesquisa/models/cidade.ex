defmodule Pescarte.Domains.ModuloPesquisa.Models.Cidade do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  schema "cidade" do
    field :county, CapitalizedString
    field :public_id, :string

    has_many :campi, Campus, on_replace: :delete

    belongs_to :contato, Contato

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:county, :contato_id])
    |> validate_required([:county])
    |> unique_constraint(:county)
    |> foreign_key_constraint(:contato_id)
    |> put_change(:public_id, Nanoid.generate())
    |> apply_action(:parse)
  end
end
