defmodule Pescarte.ResearchModulus.Services.CreateMonthlyReport do
  use Pescarte, :application_service

  alias Pescarte.ResearchModulus.IO.MonthlyReportRepo

  @impl true
  def process(params) do
    MonthlyReportRepo.insert(params)
  end
end
