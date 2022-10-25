defmodule Pescarte.ResearchModulus.Services.GetMonthlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.MonthlyReportRepo

  def process do
    MonthlyReportRepo.all()
  end

  @impl true
  def process(id: id) do
    MonthlyReportRepo.fetch(id)
  end
end
