defmodule Pescarte.ResearchModulus.Models.Researcher do
  use Pescarte, :model

  alias Pescarte.Accounts.Models.User
  alias Pescarte.ResearchModulus.Models.Campus
  alias Pescarte.ResearchModulus.Models.Midia
  alias Pescarte.ResearchModulus.Models.MonthlyReport
  alias Pescarte.ResearchModulus.Models.Researcher
  alias Pescarte.Types.TrimmedString

  @bursary_types ~w(
    ic pesquisa voluntario
    celetista consultoria
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  schema "researcher" do
    field :minibio, TrimmedString
    field :bursary, Ecto.Enum, values: @bursary_types
    field :link_lattes, TrimmedString
    field :public_id, :string

    has_many :advisored, Researcher
    has_many :midias, Midia
    has_many :monthly_reports, MonthlyReport
    has_many :quarterly_reports, QuarterlyReport
    has_many :yearly_reports, YearlyReport

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :advisor, Researcher, on_replace: :update

    timestamps()
  end
end
