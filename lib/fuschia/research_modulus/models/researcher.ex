defmodule Fuschia.ResearchModulus.Models.Researcher do
  use Fuschia, :model

  alias Fuschia.Accounts.Models.User
  alias Fuschia.ResearchModulus.Models.Campus
  alias Fuschia.ResearchModulus.Models.Midia
  alias Fuschia.ResearchModulus.Models.MonthlyReport
  alias Fuschia.ResearchModulus.Models.Researcher
  alias Fuschia.Types.TrimmedString

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

    has_many :advisored, Researcher
    has_many :midias, Midia
    has_many :monthly_reports, MonthlyReport

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :advisor, Researcher, on_replace: :update

    timestamps()
  end
end
