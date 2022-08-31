defmodule Fuschia.ResearchModulus.Services.GetMonthlyReport do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MonthlyReportRepo

  def process do
    MonthlyReportRepo.all()
  end

  @impl true
  def process(id: id) do
    MonthlyReportRepo.fetch(id)
  end
end
