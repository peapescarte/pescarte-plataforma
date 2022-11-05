defmodule Pescarte.ResearchModulus.Models.ResearchLine do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.ResearchCore
  alias Pescarte.Types.TrimmedString

  schema "research_line" do
    field :number, :integer
    field :short_desc, TrimmedString
    field :desc, TrimmedString
    field :public_id, :string

    belongs_to :research_core, ResearchCore

    timestamps()
  end
end
