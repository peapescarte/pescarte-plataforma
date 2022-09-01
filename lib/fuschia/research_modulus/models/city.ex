defmodule Fuschia.ResearchModulus.Models.City do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.Campus

  schema "city" do
    field :county, CapitalizedString
    field :public_id, :string

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end
end
