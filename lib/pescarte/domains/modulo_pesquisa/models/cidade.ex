defmodule Pescarte.Domains.ModuloPesquisa.Models.Cidade do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  schema "cidade" do
    field :county, CapitalizedString
    field :public_id, :string

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end
end
