defmodule Pescarte.ResearchModulus do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  alias Pescarte.ResearchModulus.IO.MonthlyReportRepo
  alias Pescarte.ResearchModulus.Services.CreateCampus
  alias Pescarte.ResearchModulus.Services.CreateCity
  alias Pescarte.ResearchModulus.Services.CreateMidia
  alias Pescarte.ResearchModulus.Services.CreateMonthlyReport
  alias Pescarte.ResearchModulus.Services.CreateResearchCore
  alias Pescarte.ResearchModulus.Services.CreateResearcher
  alias Pescarte.ResearchModulus.Services.CreateResearchLine
  alias Pescarte.ResearchModulus.Services.GetCampus
  alias Pescarte.ResearchModulus.Services.GetCity
  alias Pescarte.ResearchModulus.Services.GetMidia
  alias Pescarte.ResearchModulus.Services.GetMonthlyReport
  alias Pescarte.ResearchModulus.Services.GetResearchCore
  alias Pescarte.ResearchModulus.Services.GetResearcher
  alias Pescarte.ResearchModulus.Services.GetResearchLine
  alias Pescarte.ResearchModulus.Services.UpdateMidia
  alias Pescarte.ResearchModulus.Services.UpdateResearchCore

  defdelegate create_campus(params), to: CreateCampus, as: :process

  defdelegate get_campus(id), to: GetCampus, as: :process

  defdelegate list_campus, to: GetCampus, as: :process

  defdelegate create_city(params), to: CreateCity, as: :process

  defdelegate get_city(id), to: GetCity, as: :process

  defdelegate create_research_line(params), to: CreateResearchLine, as: :process

  defdelegate get_research_line(id), to: GetResearchLine, as: :process

  defdelegate list_research_line, to: GetResearchLine, as: :process

  defdelegate create_midia(params), to: CreateMidia, as: :process

  defdelegate get_midia(id), to: GetMidia, as: :process

  defdelegate list_midia, to: GetMidia, as: :process

  defdelegate update_midia(params), to: UpdateMidia, as: :process

  defdelegate create_research_core(params), to: CreateResearchCore, as: :process

  defdelegate get_research_core(id), to: GetResearchCore, as: :process

  defdelegate list_research_core, to: GetResearchCore, as: :process

  defdelegate update_research_core(params), to: UpdateResearchCore, as: :process

  defdelegate create_researcher(params), to: CreateResearcher, as: :process

  defdelegate get_researcher(id), to: GetResearcher, as: :process

  defdelegate list_researcher, to: GetResearcher, as: :process

  defdelegate create_monthly_report(params), to: CreateMonthlyReport, as: :process

  defdelegate get_monthly_report(id), to: GetMonthlyReport, as: :process

  defdelegate list_monthly_report, to: GetMonthlyReport, as: :process

  def change_monthly_report(report, attrs \\ %{}) do
    MonthlyReportRepo.changeset(report, attrs)
  end

  def list_campus_by_county(id) do
    GetCampus.process(municipio: id)
  end

  def list_research_line_by_research_core(core_id) do
    GetResearchLine.process(nucleo: core_id)
  end

  ## Generic

  defdelegate delete(source), to: Pescarte.Database
end
