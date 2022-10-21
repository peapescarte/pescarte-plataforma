defmodule Backend.ResearchModulus.Services.CreateMonthlyReport do
  use Backend, :application_service

  alias Backend.ResearchModulus.IO.MonthlyReportRepo

  @impl true
  def process(params) do
    MonthlyReportRepo.insert(params)
  end
end
