defmodule Backend.ResearchModulus.Models.Researcher do
  use Backend, :model

  alias Backend.Accounts.Models.User
  alias Backend.ResearchModulus.Models.Campus
  alias Backend.ResearchModulus.Models.Midia
  alias Backend.ResearchModulus.Models.MonthlyReport
  alias Backend.ResearchModulus.Models.Researcher
  alias Backend.Types.TrimmedString

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

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :advisor, Researcher, on_replace: :update

    timestamps()
  end
end
