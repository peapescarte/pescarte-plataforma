defmodule Pescarte.ResearchModulus.Models.City do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.Campus

  schema "city" do
    field :county, CapitalizedString
    field :public_id, :string

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end
end
