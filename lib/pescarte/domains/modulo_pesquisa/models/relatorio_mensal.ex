defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal do
  use Pescarte, :model

  import Pescarte.Domains.ModuloPesquisa.Services.ValidateRelatorioMensal

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(year month pesquisador_id)a

  @optional_fields ~w(
    link planning_action
    study_group guidance_metting
    research_actions training_participation
    publication next_planning_action
    next_study_group next_guidance_metting
    next_research_actions
  )a

  @update_fields @optional_fields ++ ~w(year month link)a

  schema "relatorio_mensal" do
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
    field :id_publico, :string

    belongs_to(:pesquisador, Pesquisador, on_replace: :update)

    timestamps()
  end

  def changeset(report \\ %__MODULE__{}, attrs) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end

  def update_changeset(report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> apply_action(:parse)
  end
end
