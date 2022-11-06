defmodule Pescarte.ResearchModulus.Models.QuarterlyReport do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.Researcher
  alias Pescarte.Types.TrimmedString

  schema "relatoriotrimestral" do
    field :title, TrimmedString
    field :abstract, TrimmedString
    field :introduction, TrimmedString
    field :theoretical_embasement, TrimmedString
    field :preliminary_results, TrimmedString
    field :academic_activities, TrimmedString
    field :non_academic_activities, TrimmedString
    field :references, TrimmedString

    field :year, :integer
    field :month, :integer
    field :link, :string
    field :public_id, :string

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
