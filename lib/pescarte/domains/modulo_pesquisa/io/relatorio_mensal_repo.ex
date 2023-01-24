defmodule Pescarte.Domains.ModuloPesquisa.IO.RelatorioMensalRepo do
  use Pescarte, :repo

  import Pescarte.Domains.ModuloPesquisa.Services.ValidateRelatorioMensal

  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

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

  def changeset(%RelatorioMensal{} = report, attrs \\ %{}) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  @impl true
  def all do
    Database.all(RelatorioMensal)
  end

  @impl true
  def fetch(id) do
    fetch(RelatorioMensal, id)
  end

  @impl true
  def insert(attrs) do
    %RelatorioMensal{}
    |> changeset(attrs)
    |> Database.insert()
  end

  @impl true
  def update(%RelatorioMensal{} = report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:month)
    |> validate_year(:year, Date.utc_today())
    |> Database.update()
  end
end
