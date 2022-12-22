defmodule Pescarte.ResearchModulus.Services.CreateYearlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.YearlyReportRepo

  @impl true
  def process(params) do
    YearlyReportRepo.insert(params)
  end
end
