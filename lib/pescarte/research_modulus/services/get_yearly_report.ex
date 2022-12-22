defmodule Pescarte.ResearchModulus.Services.GetYearlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.YearlyReportRepo

  def process do
    YearlyReportRepo.all()
  end

  @impl true
  def process(id: id) do
    YearlyReportRepo.fetch(id)
  end
end
