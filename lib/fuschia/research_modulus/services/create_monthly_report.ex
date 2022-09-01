defmodule Fuschia.ResearchModulus.Services.CreateMonthlyReport do
  use Fuschia, :application_service

  alias Fuschia.ResearchModulus.IO.MonthlyReportRepo

  @impl true
  def process(params) do
    MonthlyReportRepo.insert(params)
  end
end
