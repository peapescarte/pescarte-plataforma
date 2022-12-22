defmodule Pescarte.ResearchModulus.Models.YearlyReport do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.Researcher
  alias Pescarte.Types.TrimmedString

  @status_types ~w(novo em_edicao submetido)a

  schema "yearly_report" do
    field :plan, TrimmedString
    field :abstract, TrimmedString
    field :introduction, TrimmedString
    field :theoretical_embasement, TrimmedString
    field :results, TrimmedString
    field :academic_activities, TrimmedString
    field :non_academic_activities, TrimmedString
    field :conclusion, TrimmedString
    field :references, TrimmedString

    field :status, Ecto.Enum, values: @status_types

    field :year, :integer
    field :month, :integer
    field :link, :string
    field :public_id, :string

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
