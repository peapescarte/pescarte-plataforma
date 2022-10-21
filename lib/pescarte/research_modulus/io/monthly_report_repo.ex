defmodule Backend.ResearchModulus.IO.MonthlyReportRepo do
  use Backend, :repo

  import Backend.ResearchModulus.Services.ValidateReport

  alias Backend.ResearchModulus.Models.MonthlyReport

  @required_fields ~w(year month researcher_id)a

  @optional_fields ~w(
    link planning_action
    study_group guidance_metting
    research_actions training_participation
    publication next_planning_action
    next_study_group next_guidance_metting
    next_research_actions
  )a

  @update_fields @optional_fields ++ ~w(year month link)a

  def changeset(%MonthlyReport{} = report, attrs \\ %{}) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> foreign_key_constraint(:researcher_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  @impl true
  def all do
    Database.all(MonthlyReport)
  end

  @impl true
  def fetch(id) do
    fetch(MonthlyReport, id)
  end

  @impl true
  def insert(attrs) do
    %MonthlyReport{}
    |> changeset(attrs)
    |> Database.insert()
  end

  @impl true
  def update(%MonthlyReport{} = report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> Database.update()
  end
end
