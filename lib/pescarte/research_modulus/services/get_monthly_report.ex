defmodule Backend.ResearchModulus.Services.GetMonthlyReport do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.MonthlyReportRepo

  def process do
    MonthlyReportRepo.all()
  end

  @impl true
  def process(id: id) do
    MonthlyReportRepo.fetch(id)
  end
end
