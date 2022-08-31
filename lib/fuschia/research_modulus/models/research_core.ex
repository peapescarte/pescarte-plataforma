defmodule Fuschia.ResearchModulus.Models.ResearchCore do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.ResearchLine

  schema "research_core" do
    field :name, CapitalizedString
    field :desc, :string

    has_many :research_lines, ResearchLine

    timestamps()
  end
end
