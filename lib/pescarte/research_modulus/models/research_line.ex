defmodule Backend.ResearchModulus.Models.ResearchLine do
  use Backend, :model

  alias Backend.ResearchModulus.Models.ResearchCore
  alias Backend.Types.TrimmedString

  schema "research_line" do
    field :number, :integer
    field :short_desc, TrimmedString
    field :desc, TrimmedString
    field :public_id, :string

    belongs_to :research_core, ResearchCore

    timestamps()
  end
end
