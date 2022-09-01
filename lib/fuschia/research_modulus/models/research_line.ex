defmodule Fuschia.ResearchModulus.Models.ResearchLine do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.ResearchCore
  alias Fuschia.Types.TrimmedString

  schema "research_line" do
    field :number, :integer
    field :short_desc, TrimmedString
    field :desc, TrimmedString
    field :public_id, :string

    belongs_to :research_core, ResearchCore

    timestamps()
  end
end
