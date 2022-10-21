defmodule Backend.ResearchModulus.Models.ResearchCore do
  use Backend, :model

  alias Backend.ResearchModulus.Models.ResearchLine

  schema "research_core" do
    field :name, CapitalizedString
    field :desc, :string
    field :public_id, :string

    has_many :research_lines, ResearchLine

    timestamps()
  end
end
