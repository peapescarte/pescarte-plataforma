defmodule Fuschia.ResearchModulus.Models.City do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.Campus

  schema "cidade" do
    field :county, CapitalizedString

    has_many :campi, Campus, on_replace: :delete

    timestamps()
  end
end
