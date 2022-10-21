defmodule Backend.ResearchModulus.Models.MonthlyReport do
  use Backend, :model

  alias Backend.ResearchModulus.Models.Researcher
  alias Backend.Types.TrimmedString

  schema "relatorio" do
    # Primeira seção
    field :planning_action, TrimmedString
    field :study_group, TrimmedString
    field :guidance_metting, TrimmedString
    field :research_actions, TrimmedString
    field :training_participation, TrimmedString
    field :publication, TrimmedString

    # Segunda seção
    field :next_planning_action, TrimmedString
    field :next_study_group, TrimmedString
    field :next_guidance_metting, TrimmedString
    field :next_research_actions, TrimmedString

    field :year, :integer
    field :month, :integer
    field :link, :string
    field :public_id, :string

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
