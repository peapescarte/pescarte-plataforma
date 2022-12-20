defmodule Pescarte.ResearchModulus.IO.QuarterlyReportRepo do
  use Pescarte, :repo

  import Pescarte.ResearchModulus.Services.ValidateReport

  alias Pescarte.ResearchModulus.Models.QuarterlyReport

  @required_fields ~w(year month researcher_id)a

  @optional_fields ~w(
    link title
    abstract
    introduction
    theoretical_embasement
    preliminary_results
    academic_activities
    non_academic_activities
    references
    status
  )a

  @update_fields @optional_fields ++ ~w(year month link)a

  def changeset(%QuarterlyReport{} = report, attrs \\ %{}) do
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
    Database.all(QuarterlyReport)
  end

  @impl true
  def fetch(id) do
    fetch(QuarterlyReport, id)
  end

  @impl true
  def insert(attrs) do
    %QuarterlyReport{}
    |> changeset(attrs)
    |> Database.insert()
  end

  @impl true
  def update(%QuarterlyReport{} = report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> Database.update()
  end
end
